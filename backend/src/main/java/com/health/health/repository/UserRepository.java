package com.health.health.repository;


import com.health.health.model.UserData;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<UserData, Long> {

    Optional<UserData> findByMobilenoAndOtp(String mobileno, String otp);

    Optional<UserData> findByMobileno(String mobile);


}