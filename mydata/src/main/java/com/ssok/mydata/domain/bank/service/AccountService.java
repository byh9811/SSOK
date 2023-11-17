package com.ssok.mydata.domain.bank.service;

import com.ssok.mydata.domain.bank.repository.AccountRepository;
import com.ssok.mydata.domain.bank.entity.Account;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class AccountService {

    private final AccountRepository accountRepository;

    public void charge(String accNum, Long amt) {
        Account account = accountRepository.findByAccountNum(accNum).orElseThrow();
        account.withdraw(amt);
    }

    public void transfer(String accNum, Long amt) {
        Account account = accountRepository.findByAccountNum(accNum).orElseThrow();
        account.deposit(amt);
    }

}
