package com.health.health.Controller;

import com.health.health.model.UserData;
import com.health.health.services.OtpService;
import com.health.health.services.UserServices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class PageController {

    private static final Logger logger = LoggerFactory.getLogger(PageController.class);

    @Autowired
    private UserServices userServices;

    @Autowired
    private OtpService otpService;

    @Autowired
    private OtpController otpController;

    @PostMapping("/login")
    public ResponseEntity<String> loginUser(@RequestBody UserData userData) {
        String otp = otpService.generateOtp();
        String mobileno = userData.getMobileno();
        UserData existingUser = userServices.findByMobileNo(mobileno);

        if (existingUser != null) {
            existingUser.setOtp(otp);
            userServices.updateUser(existingUser, mobileno);
        } else {
            UserData newUser = new UserData();
            newUser.setMobileno(mobileno);
            newUser.setOtp(otp);
            userServices.saveUser(newUser);
        }

        otpController.sendOtp(mobileno, otp);
        logger.info("OTP sent to mobile number: {}", mobileno);
        return new ResponseEntity<>("OTP sent successfully", HttpStatus.OK);
    }

    @PostMapping("/login/otp-verify")
    public ResponseEntity<Map<String, Object>> loginUserVerifyOtp(@RequestBody UserData userData) {
        Map<String, Object> response = new HashMap<>();

        // Authenticate the user with the mobile number and OTP
        boolean authenticated = userServices.authenticateUser(userData.getMobileno(), userData.getOtp());
        if (!authenticated) {
            response.put("message", "Invalid OTP");
            return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
        }

        // Find the existing user by mobile number
        UserData existingUser = userServices.findByMobileNo(userData.getMobileno());
        if (existingUser == null) {
            response.put("message", "User not found");
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        }


        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PostMapping("/register")
    public ResponseEntity<Map<String, Object>> registerUser(@RequestBody UserData userData) {
        Map<String, Object> response = new HashMap<>();

        // Check if the user already exists based on the mobile number
        UserData existingUser = userServices.findByMobileNo(userData.getMobileno());


        // If the user is already registered, return an appropriate message
        response.put("message", "User already registered");


        return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
    }
}
