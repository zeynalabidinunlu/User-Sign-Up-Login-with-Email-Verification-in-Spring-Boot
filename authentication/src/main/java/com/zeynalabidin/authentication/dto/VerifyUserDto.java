package com.zeynalabidin.authentication.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class VerifyUserDto {

	private String email;
	
	private String verificationCode;
}
