Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E31C469F0C0
	for <lists+linux-bcache@lfdr.de>; Wed, 22 Feb 2023 09:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjBVIz7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 22 Feb 2023 03:55:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbjBVIz7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 22 Feb 2023 03:55:59 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27D734F55
        for <linux-bcache@vger.kernel.org>; Wed, 22 Feb 2023 00:55:57 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 308623497F;
        Wed, 22 Feb 2023 08:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677056156; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=POgDwnLnC4fTLQKyvwzyjnPDcacLQacDVY0N2llhf28=;
        b=f99wHtjlMsfzl+gquM8gRgBjFcoOFAAYuYeuUNo2Iv2YWPby4Z1D7fsAQuHsNeoPcxcNsr
        YzbLdS+upuoAOwItw0S3dg/qCvEH66ggLjEgLHK8vjMpUegqoyadKcgII0us2iBRwY05Ay
        OwASVOrPklXFc6c/NdnuHHOP9JIJXF0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677056156;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=POgDwnLnC4fTLQKyvwzyjnPDcacLQacDVY0N2llhf28=;
        b=P/3s+X5YfpY1M7zSnd+AEdCf3BGxUOevm4ZMM4/fpN+hequRwkPbWMIxLBl31Jq5QlHR7S
        M8pHcLOeixhFtaBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 57BA5139DB;
        Wed, 22 Feb 2023 08:55:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id jIOiCZvY9WPJTQAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 22 Feb 2023 08:55:55 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH v2] bcache: Add support for live resize of backing devices
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230222085333.39021-1-andrea.tomassetti-opensource@devo.com>
Date:   Wed, 22 Feb 2023 16:55:42 +0800
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B3722141-1202-42CF-9A02-8F29F2607F93@suse.de>
References: <20230222085333.39021-1-andrea.tomassetti-opensource@devo.com>
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



> 2023=E5=B9=B42=E6=9C=8822=E6=97=A5 16:53=EF=BC=8CAndrea Tomassetti =
<andrea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> When a disk changes size, udev rules are fired and register_bcache
> function get called. With this patch, every time this happens, the
> disk's capacity get checked: if it has changed then the new
> bch_update_capacity function get called, otherwise it fails as before.
>=20
> Signed-off-by: Andrea Tomassetti =
<andrea.tomassetti-opensource@devo.com>

Hi Andrea,

Thank you for the update.

I will start to do more testing for the patches from you and Zheming.

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
[snipped]

