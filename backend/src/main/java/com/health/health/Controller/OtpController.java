package com.health.health.Controller;

import com.health.health.services.OtpService;
import com.health.health.services.TwilioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/otp")
public class OtpController {

    @Autowired
    private OtpService otpService;

    @Autowired
    private TwilioService twilioService;


    public String sendOtp(String phoneNumber,String otp) {
        String formattedPhoneNumber = "+91" + phoneNumber;

        //String otp = otpService.generateOtp();

        System.out.println("{Mobile no = "+phoneNumber+" OTP = "+otp+"}");

        return twilioService.sendOtp(formattedPhoneNumber, otp);
    }
}
