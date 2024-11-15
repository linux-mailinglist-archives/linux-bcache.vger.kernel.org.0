Return-Path: <linux-bcache+bounces-788-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 001DA9CD754
	for <lists+linux-bcache@lfdr.de>; Fri, 15 Nov 2024 07:40:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7BB041F22EEA
	for <lists+linux-bcache@lfdr.de>; Fri, 15 Nov 2024 06:40:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28FEE1885BF;
	Fri, 15 Nov 2024 06:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="b7TvoYUA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xP1IImbW";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="czYKfMUn";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+2pEpGDx"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA7A188713;
	Fri, 15 Nov 2024 06:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652827; cv=none; b=aRicTO7x0ajhyixOrpFgap98+s1Zxjdk1bmJf4NehnfgA6AEdlh/IPpCPXv/WF32IlKPGt9TwcEWz7vFRbOi4/gIQpwZ+uxoJG9nUDR7yNiTtIO2CfSNKGBaaNws3+8qozl2ZgoV8+9830Um/amy7+6setLhhnFi9kPRf7G6KtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652827; c=relaxed/simple;
	bh=q1ua9vU4mVzTtv9yyz5T7Gx7G+GDgDdJrjpLAuqXChs=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=nfqoj1vOXLlfJG8LazBU9BZ4m9HvGlcqZfsLLyyMWln7j33t/y2gPGJw87wPMTRipQaCZU9TcECjFUQNaBtXtEnDDYD6e4GWj1cRYq+Nwp1DrDhaFxWgN5YSNLeEb5qHsCYjFv9lWDTartfq8ISFYUcr5P1meHCOtX1qAoUR06U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=b7TvoYUA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xP1IImbW; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=czYKfMUn; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+2pEpGDx; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B7BEE1F7E8;
	Fri, 15 Nov 2024 06:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1731652823; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nqKjoGPVS0yHvQ0U7eCIW+aIKTW7r0WfcKI3m8mcFpk=;
	b=b7TvoYUAQExHCUKPT2i7c5BOMTab5XR4BWOoXzfKGUVScnRAG1nao01PM6KEDzWw9PZ2cC
	AkKVfhAppLMDcDh5JHjcbpkfWIsSxvPYq9XHf7mL7GyXLtImC3YHXOxo4ivW708aB/IFmZ
	Kl9EBgTvQaRrRljhn9J1HrZBpYcMdCI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1731652823;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nqKjoGPVS0yHvQ0U7eCIW+aIKTW7r0WfcKI3m8mcFpk=;
	b=xP1IImbWLqyIF1gsnPTaExG6+eGj3NlJg0MiNK3GJFXUsg0dEyFohVlwgHReevitJc1fP3
	ySTA6TG9GNMdaIDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=czYKfMUn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+2pEpGDx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1731652821; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nqKjoGPVS0yHvQ0U7eCIW+aIKTW7r0WfcKI3m8mcFpk=;
	b=czYKfMUnJ0pN8cZ0bk7pf4W8zxsY/1LmRryhFVdlcB0xzQR+4CUKkmB0I/oKlJn3XbreRJ
	Hkk6bc1YYA3b6E8s2fUjQvgnxoAneR/V3cflEOdayNpu7fRZwnZOKZ1pO9MS5/Y5gq4llU
	v0qOzrXv2B5dvTFDebHsubpYuRNfBn4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1731652821;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nqKjoGPVS0yHvQ0U7eCIW+aIKTW7r0WfcKI3m8mcFpk=;
	b=+2pEpGDxeBMRlmLvENgZinqp73+buXAfs/vrfHmmcEYFM5Yh41sUV9T/kMrhIHnFIUWWX7
	fq/sqfDxENNzVwCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1A73F13485;
	Fri, 15 Nov 2024 06:40:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RwEZMtPsNmeKDwAAD6G6ig
	(envelope-from <colyli@suse.de>); Fri, 15 Nov 2024 06:40:19 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH] bcache:fix oops in cache_set_flush
From: Coly Li <colyli@suse.de>
In-Reply-To: <CAAsfc_r_6mZ2HesDOQWU-0F2KXhz=EJ_nHeR4bLanXNnAiduTg@mail.gmail.com>
Date: Fri, 15 Nov 2024 14:40:05 +0800
Cc: "mingzhe.zou@easystack.cn" <mingzhe.zou@easystack.cn>,
 Kent Overstreet <kent.overstreet@gmail.com>,
 linux-bcache <linux-bcache@vger.kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D5D1CBD5-0031-4285-BE12-910D6898B465@suse.de>
References: <CAAsfc_omvbgaSpmxqPPD9Jf4P2H-fEU97ADfRzJ0jULxGJehwg@mail.gmail.com>
 <TYZPR02MB78424F31FF023102693D2DB2A65A2@TYZPR02MB7842.apcprd02.prod.outlook.com>
 <15077D4C-8DE9-4751-9492-51D972B3E4C3@suse.de>
 <CAAsfc_r_6mZ2HesDOQWU-0F2KXhz=EJ_nHeR4bLanXNnAiduTg@mail.gmail.com>
To: liequan che <liequanche@gmail.com>
X-Mailer: Apple Mail (2.3826.200.121)
X-Rspamd-Queue-Id: B7BEE1F7E8
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[easystack.cn,gmail.com,vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TAGGED_RCPT(0.00)[];
	APPLE_MAILER_COMMON(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[run-fio-randrw.sh:url,gitee.com:url,inspur.com:email,suse.de:mid,suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 



> 2024=E5=B9=B411=E6=9C=8814=E6=97=A5 21:10=EF=BC=8Cliequan che =
<liequanche@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi colyli and mingzhe.zou:
>  I am trying to reproduce this problem, maybe it is a random problem.
> It is triggered only when IO error reading priorities occurs.
>  The same operation was performed on three servers, replacing the 12T
> disk with a 16T disk. Only one server triggered the bug. The on-site

What do you mean =E2=80=9Creplacing 12T disk with a 16T disk=E2=80=9D ?



> operation steps are as follows:
> 1. Create a bache device.
> make-bcache -C /dev/nvme2n1p1 -B /dev/sda --writeback --force =
--wipe-bcache
> /dev/sda is a 12T SATA disk.
> /dev/nvme2n1p1 is the first partition of the nvme disk. The partition
> size is 1024G.
> The partition command is parted -s --align optimal /dev/nvme2n1 mkpart
> primary 2048s 1024GiB
> 2. Execute fio test on bcache0
>=20
> cat /home/script/run-fio-randrw.sh
> bcache_name=3D$1
> if [ -z "${bcache_name}" ];then
> echo bcache_name is empty
> exit -1
> fi
>=20
> fio --filename=3D/dev/${bcache_name} --ioengine=3Dlibaio --rw=3Drandrw
> --bs=3D4k --size=3D100% --iodepth=3D128 --numjobs=3D4 --direct=3D1 =
--name=3Drandrw
> --group_reporting --runtime=3D30 --ramp_time=3D5 --lockmem=3D1G | tee =
-a
> ./randrw-iops_k1.log
> Execute bash run-fio-randrw.sh multiple times bcache0
> 2. Shutdown
> poweroff
> No bcache data clearing operation was performed

What is the =E2=80=9Cbcache data clearing operation=E2=80=9D here?=20



> 3. Replace the 12T SATA disk with a 16T SATA disk
> After shutting down, unplug the 12T hard disk and replace it with a
> 16T hard disk.

It seems you did something bcache doesn=E2=80=99t support. Replace the =
backing device...

> 4. Adjust the size of the nvme2n1 partition to 1536G
> parted -s --align optimal /dev/nvme2n1 mkpart primary 2048s 1536GiB
> Kernel panic occurs after partitioning is completed

Yes it is expected, bcache doesn=E2=80=99t support resize on cache =
device. The operation will result a corrupted meta data layout, it is =
expected.


> 5. Restart the system, but cannot enter the system normally. It is
> always in the restart state.
> 6. Enter the rescue mode through the CD, clear the nvme2n1p1 super
> block information. After restarting again, you can enter the system
> normally.
> wipefs -af /dev/nvme2n1p1

OK, the cache device is cleared.


> 7. Repartition again, triggering kernel panic again.
> parted -s --align optimal /dev/nvme2n1 mkpart primary 2048s 1536GiB
> The same operation was performed on the other two servers, and no
> panic was triggered.

I guess this is another undefine operation. I assume the cache device is =
still references somewhere. A reboot should follow the wipefs.

> The server with the problem was able to enter the system normally
> after the root of the cache_set structure was determined to be empty.
> I updated the description of the problem in the link below.

No, if you clean up the partition, no cache device will exist. Cache =
registration won=E2=80=99t treat it as a bcache device.

OK, from the above description, I see you replace the backing device =
(and I don=E2=80=99t know where the previous data was), then you extend =
the cache device size. They are all unsupported operations.

It is very possible that the unsupported operations results undefined =
aftermath.

> bugzilla: https://gitee.com/openeuler/kernel/issues/IB3YQZ
> Your suggestion was correct. I removed the unnecessary btree_cache
> iserr_or_null check.

Here in the linux-bcache mailing list, we don=E2=80=99t handle =
distribution specific bug. Unless it is in upstream too.

But from the above description IHMO they are invalid operations, so I =
don=E2=80=99t see there is a valid bug.


>  ------------
>  If the bcache cache disk contains damaged data,
> when the bcache cache disk partition is directly operated,
> the system-udevd service is triggered to call the bcache-register
> program to register the bcache device,resulting in kernel oops.
>=20
> Signed-off-by: cheliequan  <cheliequan@inspur.com>
>=20
> ---
> drivers/md/bcache/super.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index fd97730479d8..c72f5576e4da 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1741,8 +1741,10 @@ static void cache_set_flush(struct closure *cl)
>        if (!IS_ERR_OR_NULL(c->gc_thread))
>                kthread_stop(c->gc_thread);
>=20
> -       if (!IS_ERR(c->root))
> -               list_add(&c->root->list, &c->btree_cache);
> +       if (!IS_ERR_OR_NULL(c->root)) {
> +               if (!list_empty(&c->root->list))
> +                       list_add(&c->root->list, &c->btree_cache);
> +       }
>=20

The patch just avoid an explicit kernel panic of the undefined device =
status. More damages are on the way even you try to veil this panic.=20


Thanks.

Coly Li


>        /*
>         * Avoid flushing cached nodes if cache set is retiring
> --=20
> 2.33.0


