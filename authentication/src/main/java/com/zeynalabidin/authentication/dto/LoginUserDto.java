package com.zeynalabidin.authentication.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LoginUserDto {
	
	private String email;
	
	private String password;
}
