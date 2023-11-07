package com.ssok.mydata.domain.auth.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.ColumnDefault;

import javax.persistence.*;
import java.sql.Date;

@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Auth {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true)
    private String memberCi;

    private Boolean registeredAccount;

    private Boolean registeredCard;

    public void makeAccount() {
        registeredAccount = true;
    }

    public void makeCard() {
        registeredCard = false;
    }

}
