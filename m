Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B78715BDB
	for <lists+linux-bcache@lfdr.de>; Tue, 30 May 2023 12:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbjE3KdN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 30 May 2023 06:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbjE3KdL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 30 May 2023 06:33:11 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9C9F3
        for <linux-bcache@vger.kernel.org>; Tue, 30 May 2023 03:33:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3D9F521AC8;
        Tue, 30 May 2023 10:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1685442783; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N+cqxiOrsClnOdEgHEV4y7hVTcBVS1CMBWRvreS/0LI=;
        b=O7rnGlxPNN+qamtpVK0t+boN9dyklQUiAJ4HyeCAtsxi9WFGnpuHC3vF2QPE51jU/couPQ
        86xIjbpss0c63iyBLwVa/m0aHFyg8xIgwSEk1aaKhgv+9Jacryn42xJMQeJn6i1GpAOfCN
        7aqUxZmfCb6pZMEo74bu8i7ZQCI4ras=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1685442783;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N+cqxiOrsClnOdEgHEV4y7hVTcBVS1CMBWRvreS/0LI=;
        b=BIe6FnzUSNGVxU8/sLAtjr2EbrexB0ZWQSz8yW9CB7cm5+znj8pzljdCvoAnbDNo7ccxkv
        jVMTwxGxN+ucqiCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4B31713478;
        Tue, 30 May 2023 10:33:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 50yJBd3QdWQmWwAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 30 May 2023 10:33:01 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH 3/3] bcache: support overlay bcache
From:   Coly Li <colyli@suse.de>
In-Reply-To: <5e538ece-4197-55ad-6631-771b1dab28d9@eclipso.eu>
Date:   Tue, 30 May 2023 18:32:48 +0800
Cc:     mingzhe <mingzhe.zou@easystack.cn>,
        Eric Wheeler <bcache@lists.ewheeler.net>,
        Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Bcache Linux <linux-bcache@vger.kernel.org>, zoumingzhe@qq.com,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E00888E8-64D2-40B3-A4B9-1FC1D0CBB877@suse.de>
References: <20230201065202.17610-1-mingzhe.zou@easystack.cn>
 <20230201065202.17610-3-mingzhe.zou@easystack.cn>
 <e4a4362e-85d9-285d-726d-3b1df73329f8@ewheeler.net>
 <994cd286-1929-60e2-8be9-71efd825ae84@easystack.cn>
 <5e538ece-4197-55ad-6631-771b1dab28d9@eclipso.eu>
To:     Cedric de Wijs <cedric.dewijs@eclipso.eu>
X-Mailer: Apple Mail (2.3731.500.231)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B45=E6=9C=8830=E6=97=A5 17:12=EF=BC=8CCedric de Wijs =
<cedric.dewijs@eclipso.eu> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> <snip>
>>>>=20
>>>> Then we can create a cached_dev with bcache1 (flash dev) as backing =
dev.
>>>> $ make-bcache -B /dev/bcache1
>>>> $ lsblk
>>>> NAME                       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
>>>> vdf                        252:80   0   50G  0 disk
>>>> =E2=94=9C=E2=94=80bcache0                  251:0    0  100G  0 disk
>>>> =E2=94=94=E2=94=80bcache1                  251:128  0  100G  0 disk
>>>>    =E2=94=94=E2=94=80bcache2                251:256  0  100G  0 =
disk
>>>>=20
>>>> As a result there is a cached device bcache2 with backing device of =
a flash device bcache1.
>>>>          ----------------------------
>>>>          | bcache2 (cached_dev)     |
>>>>          | ------------------------ |
>>>>          | |   sdb (cache_dev)    | |
>>>>          | ------------------------ |
>>>>          | ------------------------ |
>>>>          | |   bcache1 (flash_dev)| |
>>>>          | ------------------------ |
>>>>          ----------------------------
>>>=20
>>> Does this allow an arbitrary depth of bcache stacking?
>>>=20
>>> -Eric
>>>=20
>> More than 2 layers we did not test, but should be allowed.
>> mingzhe
>>>>=20
>>>> Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
>>>> Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
>>>> ---
>>>>   drivers/md/bcache/super.c | 40 =
+++++++++++++++++++++++++++++++++++----
>>>>   1 file changed, 36 insertions(+), 4 deletions(-)
>>>>=20
>>>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>>>> index ba3909bb6bea..0ca8c05831c9 100644
>>>> --- a/drivers/md/bcache/super.c
>>>> +++ b/drivers/md/bcache/super.c
> <snip>
>=20
> Hi All,
>=20
> I've not seen this commit appear in the mainline kernel yet. In 2023, =
only this commit changed super.c in 2023:
> 2023-04-25 block/drivers: remove dead clear of random flag
> =
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/dri=
vers/md/bcache/super.c?h=3Dv6.4-rc4
>=20
> What's preventing this patch from going into the mainline kernel?

Code reviewer is the bottleneck. This series is in my todo list, but not =
on it yet. If Junhui Tang, or Guoju Fang may help to review the code, it =
can be a bit faster.
Of course if Kent reviews the code and supportive, I will take it =
immediately.

Thanks.

Coly Li

