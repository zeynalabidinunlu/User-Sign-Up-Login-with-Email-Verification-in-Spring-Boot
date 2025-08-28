package com.zeynalabidin.authentication.responses;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LoginResponse {
	


	private String token;
	
	private long expiresIn;
	
	public LoginResponse(String token, long expiresIn) {
		super();
		this.token = token;
		this.expiresIn = expiresIn;
	}

}
