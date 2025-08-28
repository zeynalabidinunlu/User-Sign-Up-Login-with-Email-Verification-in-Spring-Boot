package com.zeynalabidin.authentication.service;


import org.springframework.stereotype.Service;

import com.zeynalabidin.authentication.model.User;
import com.zeynalabidin.authentication.repository.UserRepository;

import java.util.ArrayList;
import java.util.List;

@Service
public class UserService {
    private final UserRepository userRepository;
    public UserService(UserRepository userRepository, EmailService emailService) {
        this.userRepository = userRepository;
    }

    public List<User> allUsers() {
        List<User> users = new ArrayList<>();
        userRepository.findAll().forEach(users::add);
        return users;
    }
}