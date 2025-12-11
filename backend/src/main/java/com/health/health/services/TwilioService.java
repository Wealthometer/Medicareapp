package com.health.health.services;

import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class TwilioService {

    private final String fromPhoneNumber;

    // Constructor injection for Twilio credentials
    public TwilioService(@Value("${twilio.account.sid}") String accountSid,
                         @Value("${twilio.auth.token}") String authToken,
                         @Value("${twilio.phone.number}") String fromPhoneNumber) {
        this.fromPhoneNumber = fromPhoneNumber;

        // Initialize Twilio with the provided credentials
        Twilio.init(accountSid, authToken);
    }

    // Method to send OTP via SMS
    public String sendOtp(String toPhoneNumber, String otp) {
        try {
            Message message = Message.creator(
                    new PhoneNumber(toPhoneNumber),   // To phone number
                    new PhoneNumber(fromPhoneNumber), // From Twilio phone number
                    "Your OTP is: " + otp             // Message content
            ).create();

            return "OTP sent successfully to " + toPhoneNumber;
        } catch (Exception e) {
            return "Error while sending OTP: " + e.getMessage();
        }
    }
}
