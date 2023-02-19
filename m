Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F56C69BFD6
	for <lists+linux-bcache@lfdr.de>; Sun, 19 Feb 2023 10:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjBSJrO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 19 Feb 2023 04:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjBSJrN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 19 Feb 2023 04:47:13 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E372C7DBF
        for <linux-bcache@vger.kernel.org>; Sun, 19 Feb 2023 01:46:36 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B005D2018C;
        Sun, 19 Feb 2023 09:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1676799590; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=12MOpbx7SMG3xGxCDGyPOgIIsQajLh0nPmwH7FIlrlk=;
        b=EWVHrw8CFP+2vNawKN+nLtQ9WqBqjx1Sx85AdsA9UdnuoEm9CABIc2xfTbr7lnujOM5cJG
        L+nCnXQc6CMYntYTDYqFJkRWNu7yXVB8n2p2fPaXqqUI7xxiLfdZrpb1GNUsp5+5CpVH8S
        ZswmLzR1b+ITOXZXYoJSWB6Wtop3IlU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1676799590;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=12MOpbx7SMG3xGxCDGyPOgIIsQajLh0nPmwH7FIlrlk=;
        b=a4pbSKMLA8WvQBYfd+dD0oy5SMhYLuwFJyojo+2WzcGvXgf/FYE6aTN7dg4K4XkgEoXEkF
        X+xqjw/bbRAGuJDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9FC78139ED;
        Sun, 19 Feb 2023 09:39:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id LQjzGWLu8WPnGAAAMHmgww
        (envelope-from <colyli@suse.de>); Sun, 19 Feb 2023 09:39:46 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [RFC] Live resize of backing device
From:   Coly Li <colyli@suse.de>
In-Reply-To: <50e64fcd-3bd8-4175-c96e-5fa2ffe051d4@devo.com>
Date:   Sun, 19 Feb 2023 17:39:31 +0800
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8C5EA413-6FBB-4483-AAFA-2BC0A083C30D@suse.de>
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
To:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B41=E6=9C=8827=E6=97=A5 20:44=EF=BC=8CAndrea Tomassetti =
<andrea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> =46rom 83f490ec8e81c840bdaf69e66021d661751975f2 Mon Sep 17 00:00:00 =
2001
> From: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
> Date: Thu, 8 Sep 2022 09:47:55 +0200
> Subject: [PATCH v2] bcache: Add support for live resize of backing =
devices
>=20
> Signed-off-by: Andrea Tomassetti =
<andrea.tomassetti-opensource@devo.com>

Hi Andrea,

I am fine with this patch and added it in my test queue now. Do you have =
an updated version, (e.g. more coding refine or adding commit log), then =
I can update my local version.

BTW, it could be better if the patch will be sent out as a separated =
email.

Thanks.

Coly Li



> ---
> Hi Coly,
> this is the second version of the patch. As you correctly pointed out,
> I implemented roll-back functionalities in case of error.
> I'm testing this funcionality using QEMU/KVM vm via libvirt.
> Here the steps:
>  1. make-bcache --writeback -B /dev/vdb -C /dev/vdc
>  2. mkfs.xfs /dev/bcache0
>  3. mount /dev/bcache0 /mnt
>  3. dd if=3D/dev/random of=3D/mnt/random0 bs=3D1M count=3D1000
>  4. md5sum /mnt/random0 | tee /mnt/random0.md5
>  5. [HOST] virsh blockresize <vm-name> --path <disk-path> --size =
<new-size>
>  6. xfs_growfs /dev/bcache0
>  6. Repeat steps 3 and 4 with a different file name (e.g. random1.md5)
>  7. umount/reboot/remount and check that the md5 hashes are correct =
with
>        md5sum -c /mnt/random?.md5
>=20
> drivers/md/bcache/super.c | 84 ++++++++++++++++++++++++++++++++++++++-
> 1 file changed, 83 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index ba3909bb6bea..1435a3f605f8 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
>>=20

[snipped]

