package com.health.health.services;

import org.springframework.stereotype.Service;

import java.util.Random;

@Service
public class OtpService {

    private static final int OTP_LENGTH = 6;

    // Method to generate random OTP
    public String generateOtp() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000); // Generates a 6-digit OTP
        return String.valueOf(otp);
    }
}
