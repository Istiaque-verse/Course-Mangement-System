package com.cms.util;

public class PasswordHashGenerator {
    public static void main(String[] args) {
        String hash = PasswordUtil.hashPassword("admin123");
        System.out.println(hash);
    }
}
