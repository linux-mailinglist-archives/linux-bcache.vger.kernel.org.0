Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB3069CB0A
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Feb 2023 13:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbjBTMaS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 20 Feb 2023 07:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbjBTMaQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 20 Feb 2023 07:30:16 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04AA210EE
        for <linux-bcache@vger.kernel.org>; Mon, 20 Feb 2023 04:30:00 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4FF5F201A7;
        Mon, 20 Feb 2023 12:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1676896199; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/49YQ+04oGEP6R3nFwFV2HyER4+QMHhY6w35VRboELA=;
        b=eZRVHk4WjiAYYjt1V10iquthT3T9XqzD2hiEUAQIQRINnkwG8+XCQ3iTV1dlGRdQQNZhrg
        50+0p0i0oT4SxFavbOf/x9oXjWOnda1Vpa7fdXfo5aPyczEyKuzZND1KRDIKoGATq7nITk
        N1llRgpDUkK/kD0ezO2LjJnQxQQFkQk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1676896199;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/49YQ+04oGEP6R3nFwFV2HyER4+QMHhY6w35VRboELA=;
        b=8Xm/jd7UUbSUlOiyf5QFPqrbRQ2M3lh9zlMh74f6kdkzsqeNJFNVMr+zh2ifXFDfWe+N6G
        ckuxRR8dGlrmdDAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 021F0139DB;
        Mon, 20 Feb 2023 12:29:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id J9m5L8Vn82OqbQAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 20 Feb 2023 12:29:57 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [RFC] Live resize of backing device
From:   Coly Li <colyli@suse.de>
In-Reply-To: <cd023413-a05c-0f63-cde7-ed019b811575@easystack.cn>
Date:   Mon, 20 Feb 2023 20:29:45 +0800
Cc:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>,
        Eric Wheeler <bcache@lists.ewheeler.net>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <266DA9D9-CD6A-420F-8FB2-CE47489D74E1@suse.de>
References: <CAHykVA5sgGooeRjM1EepCCpZqkvtQJ_=cY8hmjqe0oQ3FLDFnQ@mail.gmail.com>
 <9474c19e-56f0-cb4d-68c-405c55aef281@ewheeler.net>
 <CAHykVA4zGN=WA4A3njQ3VdX4age2-AXq3EcW1qRTFbf=o1=yDw@mail.gmail.com>
 <4ddb082f-cefc-644e-2ccf-56d41207ecd3@devo.com>
 <107e8ceb-748e-b296-ae60-c2155d68352d@suse.de>
 <CAHykVA4WfYysOcKnQETkUyUjx_tFypFCWYG1RidRMVNqObGmRg@mail.gmail.com>
 <B7718488-B00D-4F72-86CA-0FF335AD633F@suse.de>
 <CAHykVA7_e1r9x2PfiDe8czH2WRaWtNxTJWcNmdyxJTSVGCxDHA@mail.gmail.com>
 <755CAB25-BC58-4100-A524-6F922E1C13DC@suse.de>
 <50e64fcd-3bd8-4175-c96e-5fa2ffe051d4@devo.com>
 <8C5EA413-6FBB-4483-AAFA-2BC0A083C30D@suse.de>
 <cd023413-a05c-0f63-cde7-ed019b811575@easystack.cn>
To:     mingzhe <mingzhe.zou@easystack.cn>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B42=E6=9C=8820=E6=97=A5 16:27=EF=BC=8Cmingzhe =
<mingzhe.zou@easystack.cn> =E5=86=99=E9=81=93=EF=BC=9A
>=20
>=20
>=20
> =E5=9C=A8 2023/2/19 17:39, Coly Li =E5=86=99=E9=81=93:
>>> 2023=E5=B9=B41=E6=9C=8827=E6=97=A5 20:44=EF=BC=8CAndrea Tomassetti =
<andrea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> =46rom 83f490ec8e81c840bdaf69e66021d661751975f2 Mon Sep 17 00:00:00 =
2001
>>> From: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
>>> Date: Thu, 8 Sep 2022 09:47:55 +0200
>>> Subject: [PATCH v2] bcache: Add support for live resize of backing =
devices
>>>=20
>>> Signed-off-by: Andrea Tomassetti =
<andrea.tomassetti-opensource@devo.com>
>> Hi Andrea,
>> I am fine with this patch and added it in my test queue now. Do you =
have an updated version, (e.g. more coding refine or adding commit log), =
then I can update my local version.
>> BTW, it could be better if the patch will be sent out as a separated =
email.
>> Thanks.
>> Coly Li
> Hi, Coly
>=20
> I posted some patchsets about online resize.
>=20
> -[PATCH v5 1/3] bcache: add dirty_data in struct bcache_device
> -[PATCH v5 2/3] bcache: allocate stripe memory when =
partial_stripes_expensive is true
> -[PATCH v5 3/3] bcache: support online resizing of cached_dev
>=20
> There are some differences:
> 1. Create /sys/block/bcache0/bcache/size in sysfs to trigger resize
> 2. Allocate stripe memory only if partial_stripes_expensive is true
> 3. Simplify bcache_dev_sectors_dirty()
>=20
> Since the bcache superblock uses some sectors, the actual space of the =
bcache device is smaller than the backing. In order to provide a bcache =
device with a user-specified size, we need to create a backing device =
with a larger space, and then resize bcache. So resize can specify the =
size is very necessary.
>=20
>=20

Yes, they are in my for-test queue already. I will test both and make a =
choice.

Thanks.

Coly Li

[snipped]

