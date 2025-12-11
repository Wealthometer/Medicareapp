package com.health.health.services;

import com.health.health.model.UserData;
import com.health.health.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.Optional;


@Service
public class UserServices {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public UserData registerUser(String mobileno, String otp){


            if(userRepository.findByMobileno(mobileno).isPresent()){
                System.out.println("Duplicate Login");
                return null;
            }

            UserData userData = new UserData();


            userData.setMobileno(mobileno);
            userData.setOtp(otp);

            userRepository.save(userData);
            return userData;

    }
    
    public boolean authenticateUser(String mobileno, String otp) {
        Optional<UserData> user = userRepository.findByMobilenoAndOtp(mobileno, otp);

        // Check if user is found and OTP matches
        return user.isPresent();
    }
    public UserData findByMobileNo(String mobileno) {
        return userRepository.findByMobileno(mobileno).orElse(null);
    }

    public boolean updateOtpInDatabase(String mobileNo, String otp) {
        String sql = "UPDATE user_info SET otp = ? WHERE mobileno = ?";
        int result = jdbcTemplate.update(sql, otp, mobileNo);
        return result > 0;
    }

    public void saveUser(UserData userData) {
        userRepository.save(userData);
    }

    public void updateUser(UserData updatedUserData, String mobileno) {
        // Find the existing user by mobile number
        Optional<UserData> existingUserOptional = userRepository.findByMobileno(mobileno);

        if (existingUserOptional.isPresent()) {
            UserData existingUser = existingUserOptional.get();

            // Update the necessary fields from updatedUserData

            existingUser.setOtp(updatedUserData.getOtp());

            // Save the updated user
            userRepository.save(existingUser);
        } else {
            // Handle case where the user does not exist
            throw new RuntimeException("User with mobile number " + mobileno + " not found.");
        }
    }


}