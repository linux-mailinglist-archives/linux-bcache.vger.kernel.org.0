Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4788E56708F
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Jul 2022 16:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbiGEOL4 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 5 Jul 2022 10:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbiGEOLZ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 5 Jul 2022 10:11:25 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C663320F6C
        for <linux-bcache@vger.kernel.org>; Tue,  5 Jul 2022 07:04:06 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5C5881FEDE;
        Tue,  5 Jul 2022 14:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1657029845; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QnseNG3WwhsXbOOwFVSacGZ1bV7o/moQYTRUXh3rN24=;
        b=1QeDrr4dihJ6sylQNvFVHkWtt1Q4gF44BD1QGnf94Dqb0SsbT5qNWkPI75X5iVVMucQF7y
        9q5V9za/Rb8b24tNoKUq7svoD96ESiJPwGREg9OS2ye862PiCH7czrCPy9PjiOpNtB1Y5n
        6VjYeM67mhRGN8Cr5jIF+CnVQ2vx9kc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1657029845;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QnseNG3WwhsXbOOwFVSacGZ1bV7o/moQYTRUXh3rN24=;
        b=/CDxUTUF+tk2sO9O4JLCRtpk1zj64Zqw5B+eSZshFpW2KDX4+oDKkudXAkT4EHPaPSnRL4
        fNTQbI6WjJlkazBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0E4581339A;
        Tue,  5 Jul 2022 14:04:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Z78+MdNExGJQdAAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 05 Jul 2022 14:04:03 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH] bcache: Use bcache without formatting existing device
From:   Coly Li <colyli@suse.de>
In-Reply-To: <CAHykVA48C-8JBsyZG8_iGzBJ9rjDMrW7O0mk9L4PDpRAP0yUXQ@mail.gmail.com>
Date:   Tue, 5 Jul 2022 22:04:00 +0800
Cc:     linux-bcache@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Zhang Zhen <zhangzhen.email@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <365F8F51-8D66-4DCB-BF05-50727F83B80A@suse.de>
References: <20220704151320.78094-1-andrea.tomassetti-opensource@devo.com>
 <B18A4668-47F5-4219-8336-EDB00D0292C2@suse.de>
 <CAHykVA48C-8JBsyZG8_iGzBJ9rjDMrW7O0mk9L4PDpRAP0yUXQ@mail.gmail.com>
To:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B47=E6=9C=885=E6=97=A5 16:48=EF=BC=8CAndrea Tomassetti =
<andrea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Mon, Jul 4, 2022 at 5:29 PM Coly Li <colyli@suse.de> wrote:
>>=20
>>=20
>>=20
>>> 2022=E5=B9=B47=E6=9C=884=E6=97=A5 23:13=EF=BC=8CAndrea Tomassetti =
<andrea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> Introducing a bcache control device (/dev/bcache_ctrl)
>>> that allows communicating to the driver from user space
>>> via IOCTL. The only IOCTL commands currently implemented,
>>> receives a struct cache_sb and uses it to register the
>>> backing device without any need of formatting them.
>>>=20
>>> Signed-off-by: Andrea Tomassetti =
<andrea.tomassetti-opensource@devo.com>
>>> ---
>>> Hi all,
>>> At Devo we started to think of using bcache in our production =
systems
>>> to boost performance. But, at the very beginning, we were faced with
>>> one annoying issue, at least for our use-case: bcache needs the =
backing
>>> devices to be formatted before being able to use them. What's really
>>> needed is just to wipe any FS signature out of them. This is =
definitely
>>> not an option we will consider in our production systems because we =
would
>>> need to move hundreds of terabytes of data.
>>>=20
>>> To circumvent the "formatting" problem, in the past weeks I worked =
on some
>>> modifications to the actual bcache module. In particular, I added a =
bcache
>>> control device (exported to /dev/bcache_ctrl) that allows =
communicating to
>>> the driver from userspace via IOCTL. One of the IOCTL commands that =
I
>>> implemented receives a struct cache_sb and uses it to register the =
backing
>>> device. The modifications are really small and retro compatible. To =
then
>>> re-create the same configuration after every boot (because the =
backing
>>> devices now do not present the bcache super block anymore) I created =
an
>>> udev rule that invokes a python script that will re-create the same
>>> scenario based on a yaml configuration file.
>>>=20
>>> I'm re-sending this patch without any confidentiality footer, sorry =
for that.
>>=20
>> Thanks for removing that confidential and legal statement, that=E2=80=99=
s the reason I was not able to reply your email.
>>=20
> Thank you for your patience and sorry for the newbie mistake.
>> Back to the patch, I don=E2=80=99t support this idea. For the problem =
you are solving, indeed people uses device mapper linear target for many =
years, and it works perfectly without any code modification.
>>=20
>> That is, create a 8K image and set it as a loop device, then write a =
dm table to combine it with the existing hard drive. Then you run =
=E2=80=9Cbcache make -B <combined dm target>=E2=80=9D, you will get a =
bcache device whose first 8K in the loop device and existing super block =
of the hard driver located at expected offset.
>>=20
> We evaluated this option but we weren't satisfied by the outcomes for,
> at least, two main reasons: complexity and operational drawbacks.
> For the complexity side: in production we use more than 20 HD that
> need to be cached. It means we need to create 20+ header for them, 20+
> loop devices and 20+ dm linear devices. So, basically, there's a 3x
> factor for each HD that we want to cache. Moreover, we're currently
> using ephemeral disks as cache devices. In case of a machine reboot,
> ephemeral devices can get lost; at this point, there will be some =
trouble
> to mount the dm-linear bcache backing device because there will be no
> cache device.

OK, I get your point. It might make sense for your situation, although I =
know some other people use the linear dm-table to solve similar =
situation but may be not perfect for you.
This patch may work in your procedure, but there are following things =
make me uncomfortable,
- Copying a user space memory and directly using it as a complicated =
in-kernel memory object.
- A new IOCTL interface added, even all rested interface are sysfs =
based.
- Do things in kernel space while there is solution in user space.

All the above opinions are quite personal to myself, I don=E2=80=99t say =
you are wrong or I am correct. If the patch works, that=E2=80=99s cool =
and you can use it as you want, but I don=E2=80=99t support it to be in =
upstream.

>=20
> For the operational drawbacks: from time to time, we exploit the
> online filesystem resize capability of XFS to increase the volume
> size. This would be at least tedious, if not nearly impossible, if the
> volume is mapped inside a dm-linear.

Currently bcache doesn=E2=80=99t support cache or backing device resize. =
I don=E2=80=99t see the connection between above statement and feeding =
an in-memory super block via IOCTL command.


>> It is unnecessary to create a new IOCTL interface, and I feel the way =
how it works is really unconvinced for potential security risk.
>>=20
> Which potential security risks concern you?
>=20

Currently we don=E2=80=99t check all members of struct cache_sb_disk, =
what we do is to simply trust bcache-tools. Create a new IOCTL interface =
to send a user space memory into kernel space as superblock, that needs =
quite a lot of checking code to make sure it won=E2=80=99t panic the =
kernel. It is possible, but it is not worthy to add so many code for the =
purpose, especially adding them into upstream code.

I am not able to provide an explicit example for security risk, just the =
new adding interface makes me not so confident.

Thanks.

Coly Li



