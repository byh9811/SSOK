package com.ssok.member.domain.repository;

import com.ssok.member.domain.entity.Member;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface MemberRepository extends JpaRepository<Member, Long> {
    Optional<Member> findMemberByMemberId(String loginId);
    Optional<Member> findMemberByMemberIdAndMemberPassword(String loginId, String password);

    Optional<Member> findMemberByMemberUuid(String UUID);

    Optional<Member> findMemberByMemberSeq(Long memberSeq);

    Optional<Member> findMemberByMemberRefreshToken(String refreshToken);
}
