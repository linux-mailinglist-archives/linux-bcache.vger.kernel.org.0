Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60FB0583F00
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Jul 2022 14:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238100AbiG1Miy (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 28 Jul 2022 08:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238757AbiG1Miy (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 28 Jul 2022 08:38:54 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B62468DF7
        for <linux-bcache@vger.kernel.org>; Thu, 28 Jul 2022 05:38:53 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7F59E21CE4;
        Thu, 28 Jul 2022 12:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659011869; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vN5aNEazOW1+tAzjywvCqI8jeByUYe8xKuELkrqoOVk=;
        b=kaW3nx1uNVMA2q7PWJQ+0nC33GWftSGtx9fT3p/Q6rQPAVY3gAdZyERbcMOVvg5a4CSwf4
        1CbkI/ud8su/SaZQYstlNXcu/rms+1Or+txQBBP+u0kWT28lNtwWEHvImdlmG87Tzco4o8
        dzQKbtKliwe92KrPEuaw863Me/argfs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659011869;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vN5aNEazOW1+tAzjywvCqI8jeByUYe8xKuELkrqoOVk=;
        b=dz8XNs9qCiLL9h6ImokZKlBpHtoyf/UeqYokfWc8l7UqQ1O8SHMVHWvfhzHbgZtRetetqk
        B5BnwK6e6tgCQuCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C45B413A7E;
        Thu, 28 Jul 2022 12:37:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id PbRzJByD4mLoLgAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 28 Jul 2022 12:37:48 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: Some persistently stuck cache devices after backing device
 failures
From:   Coly Li <colyli@suse.de>
In-Reply-To: <b968c31a-aeeb-28fd-78ef-d38344d4ecc1@ehuk.net>
Date:   Thu, 28 Jul 2022 20:37:45 +0800
Cc:     linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B282B4DF-D42C-49BD-9D59-0D2140A210CE@suse.de>
References: <b968c31a-aeeb-28fd-78ef-d38344d4ecc1@ehuk.net>
To:     eddie@ehuk.net
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B47=E6=9C=8822=E6=97=A5 00:18=EF=BC=8CEddie Chapman =
<eddie@ehuk.net> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hello,
>=20
> I've been using bcache for several years and have learned how to =
resolve various problems. However now I have a situation on a live =
server where I've tried everything but looks like I might have to reboot =
the kernel to resolve it. This will be a big pain for this server so =
thought I'd check here if anyone knows something else I could try.
>=20
> Let me try and describe the situation:
>=20
> - system is running vanilla stable kernel 5.10.107 for 100+ days
> - There's a single nvme device with 15 partitions
> - Each nvme partition is a bcache cache device in writeback mode, =
attached to a backing device of course (there are various types of =
backing devices)
> - Now a SATA controller has completely failed and taken out 3 spinning =
SATA disks, leading to several backing devices but not all failing.
> - The nvme device is fine and still acting as cache for some =
remaining, working backing devices which have nothing to do with the =
failed disks.
> - The bcache backing devices that failed and their corresponding =
caches were in a mixed state immediately after the disks failed, some =
gone, some not.
> - I don't care about any of the failed data, I just want to clean up =
the mess and re-use the nvme partitions that had backing device failures =
with some other working spinning disks on the system.
> - So, I've been able to unregister, free, wipe and re-use MOST of the =
cache devices that had failed backing devices.
> - Of the cache devices I unregistered I've been able to clean up =
completely their failed backing devices (both the bcacheN device and =
failed backing device is completely gone from /sys/block).
> - However, there are 3 cache devices, with failed backing devices, =
which completely refuse to either stop or unregister. I have written 1 =
many times to the "stop" and "unregister" files but nothing changes and =
nothing is logged in the kernel log.
> - There has not been any crash or warning emitted by bcache in the =
kernel log, just the normal messages you would expect to see when =
backing devices fail.
>=20
> For each of these 3 "stuck" cache devices:
>=20
>  - The cache directory still exists in /sys/fs/bcache/
>  - Inside the cache directory there is no bdev0 symlink anymore. There =
*is* the cache0 symlink pointing to the nvme partition.
>  - The corresponding /sys/block/bcacheN directory does still exist.
>  - There is nothing in the /sys/block/bcacheN/holders/ directory. =
Above the bcache device was LVM devices but I was able to successfully =
remove all of them with dmsetup remove. There is definitely nothing =
above still holding the bcacheN device still open.
>  - The failed backing device, which is an md raid0, still exists on =
the system, but it is not possible to stop it with mdadm, it is also =
"stuck" (I've tried to normally "fail" and "remove" it as well as using =
mdadm's special "failed" and "detached" keywords). It still shows up in =
/proc/mdstat. The raid members are the SATA disks which have now =
disappeared. mdadm -D says the array is in a state "broken, FAILED" and =
it's disks are all "missing".
>  - Inside the /sys/block/mdN/ directory there is NO "bcache" =
subdirectory
>  - Inside the /sys/block/mdN/holders/ directory there is still a =
working "bcacheN" symlink to /sys/block/bcacheN
>  - Inside the /sys/block/bcacheN directory there is a broken "bcache" =
symlink pointing to the now disappeared /sys/block/mdN/bcache
>=20
>=20
> As I said, I don't care about any of the failed data, I only care =
about freeing the nvme cache devices. But I have 2 problems:
>=20
> 1. Something in the kernel is constantly reading hundreds of Mbytes/s =
of data from the 3 "stuck" nvme partitions (but not writing anything, at =
least not at any significant rate). I can see it using atop. I'm =
wondering if bcache is stuck in a loop trying to read something from =
them and that is why it will not let go of these remaining 3 nvme =
partitions. I believe this is affecting performance of the nvme device =
as a whole for the other working bcache devices using it. load average =
is quite high continually as a result.
>=20
> 2. I cannot re-use these 3 nvme partitions while they are "stuck", =
though this is less of a problem that 1.
>=20
> I'm hoping there might be a simple way to force bcache to "let go" of =
these 3 cache devices without rebooting? I don't care if the leftover =
stuff of the md backing devices doesn't go away, it is not doing any =
harm that I can tell, just that I can successfully unregister the cache =
devices. Or at least stop bcache from constantly reading the hundreds of =
Mbyte/s, I could live with just that.
>=20
> I see there is an "io_disable" file in the "internal" subdirectory. =
What does that do? Maybe it is the solution but I dare not try it as I =
don't know what it does and don't want to risk crashing the kernel.
>=20

The io_disable option might be helpful but I don=E2=80=99t recommend. =
Setting it to 1 will directly reject all external and internal I/Os =
inside bcache driver, most of time it just triggers errors and forces =
the cache or backing device to stop, but sometimes if the I/O error is =
unrecoverable in critical I/O path it may trigger kernel panic in upper =
layer code.

BTW, does it help a bit if you write 1 to =
/sys/fs/bcache/pendings_cleanup?

Coly Li



