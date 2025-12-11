package com.health.health.model;


import jakarta.persistence.*;

import java.util.Objects;

@Entity
@Table(name = "userInfo")
public class UserData {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Integer id;
    String mobileno;


    String otp;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        UserData userData = (UserData) o;
        //return Objects.equals(id, userData.id) && Objects.equals(name, userData.name) && Objects.equals(email, userData.email) && Objects.equals(mobileno, userData.mobileno) && Objects.equals(type, userData.type) && Objects.equals(otp, userData.otp);
        return Objects.equals(id, userData.id)  && Objects.equals(mobileno, userData.mobileno)  && Objects.equals(otp, userData.otp);
    }

    @Override
    public int hashCode() {
        //return Objects.hash(id, name, email, mobileno, type, otp);
        return Objects.hash(id,mobileno,otp);
    }

    @Override
    public String toString() {
        return "UserData{" +
                "id=" + id +

                //", email='" + email + '\'' +
                ", mobileno='" + mobileno + '\'' +

                ", otp='" + otp + '\'' +
                '}';
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getOtp() {
        return otp;


    }

    public void setOtp(String otp) {
        this.otp = otp;
    }



    public String getMobileno() {
        return mobileno;
    }

    public void setMobileno(String mobileno) {
        this.mobileno = mobileno;
    }

    //public String getEmail() {
       // return email;
   // }

    //public void setEmail(String email) {
      //  this.email = email;
    //}


}
