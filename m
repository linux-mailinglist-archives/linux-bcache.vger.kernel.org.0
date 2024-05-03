Return-Path: <linux-bcache+bounces-424-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C2768BB2FE
	for <lists+linux-bcache@lfdr.de>; Fri,  3 May 2024 20:25:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F2FA71F21266
	for <lists+linux-bcache@lfdr.de>; Fri,  3 May 2024 18:25:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8EEA158A0B;
	Fri,  3 May 2024 18:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="n4xX3v+d";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AyR7Qhkm";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bhpbQTtp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="K86onHOr"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915F5481B9
	for <linux-bcache@vger.kernel.org>; Fri,  3 May 2024 18:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714760660; cv=none; b=X1t3WZYa6FFhhvmll7NKBqobecchJA/kYDPpl7FSwhlfuZg0JvVtCflBEcHKlU8iTwA2dfifq9Nabh2bH+i5Zg9G1IT2D/IEAjrojwkJGxbDhDsuI9zYYUyakNXK/adOrkN12UdNG5yEq5eJfvMHEFJcyvBhgzEGfgKfz61gdJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714760660; c=relaxed/simple;
	bh=ieNz+KIuxAERpSva16AZB5xRbl8RzWKyj6+K2SCKoNw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Cu0NUDSvR4fey7YhYrF32hdnNT003ljV8nWIGuUpZHulER20tgIkzvDgTh4rRNpWs4b2zJfC4El1H8uRaPz6aZc7FU8bvTa5aTEwT6q1kQsF08GnwClTp9aQ5iNLdk+rQotNwQAtbjHq0QRoGNyS/4HRJ1TTHx+0HKUgDNp4Dv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=n4xX3v+d; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AyR7Qhkm; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bhpbQTtp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=K86onHOr; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A1641206C0;
	Fri,  3 May 2024 18:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714760650; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FdxU6eOijKAwyLGNCrSAajDPC5O60n26Nw2C7I1RjkE=;
	b=n4xX3v+dbltIoR7rRiAaExYIANWLqeYjr85xYj/9AE9hvEaiXbwHT0ZV+HFrh/ukW/x3Fk
	nhT9JwLQ5A+VnQIX3jZqT47URiU/nfFg330OfmpIJB20veKQMi3UO2JFVyHnb80UPsJMZF
	rUdEsixLHfZPAurJoIdSViked8fzY2g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714760650;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FdxU6eOijKAwyLGNCrSAajDPC5O60n26Nw2C7I1RjkE=;
	b=AyR7Qhkm5t2tN+GocTD0pHOV72k8TTajcA1zXf5y7ipd2jUej14fV37zUbbkPDGK9GECed
	Vqxp2Me0aTthLzCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bhpbQTtp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=K86onHOr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714760649; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FdxU6eOijKAwyLGNCrSAajDPC5O60n26Nw2C7I1RjkE=;
	b=bhpbQTtpENdqTG1X+4kkJKk5CVx9UFJqVeltcU1FFYGHCBCv7DtyRLP5JSxb6BpV8k0qo6
	ISjwkah9yjnzYevpC+QzzJ6L1iQ3AVDEQWlZVLlM6NJ/6DF8/Vz29332Yl2DK2kc0FWlEU
	oF4w/7MlySB/wDXQiCbnAC6AcG945J4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714760649;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FdxU6eOijKAwyLGNCrSAajDPC5O60n26Nw2C7I1RjkE=;
	b=K86onHOr3dpOFP372e8qZwcGPU5BytAoTHeNbtfCjhM4Hb2zp/AzY9hyWn9OPIDrRjYj/9
	vnKHGQVmmiVtQ5Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8627B139CB;
	Fri,  3 May 2024 18:24:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mGZ8EMgrNWYEYgAAD6G6ig
	(envelope-from <colyli@suse.de>); Fri, 03 May 2024 18:24:08 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH v2] bcache: allow allocator to invalidate bucket in gc
From: Coly Li <colyli@suse.de>
In-Reply-To: <CAJhEC05hzf2zVyJabVExFNF0esiLovc+WLHOY_YhV22OUdGFZw@mail.gmail.com>
Date: Sat, 4 May 2024 02:23:09 +0800
Cc: Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5C71FFC2-B22E-4FC2-852F-F40BFDEDFB2C@suse.de>
References: <1ddde040-9bde-515a-1d4d-b41de472a702@suse.de>
 <20240315224527.694458-1-robertpang@google.com>
 <584A2724-ACA2-4000-A8D2-50B6AA5684A7@suse.de>
 <CAJhEC06dsqq2y4MNCW7t52cPc1=PbStGTBOddZofg4vqGKkQsA@mail.gmail.com>
 <5B79FFA6-1995-4167-8318-3EDCC6F0B432@suse.de>
 <CAJhEC07hAWsW5Aq0=hCCAXJGKU47L_n8a0mQ-SjOq2wqGAj_gA@mail.gmail.com>
 <CAJhEC05TrboyqKAn0i5D72LWBs7bZ05qFrPedgmNWy8A7qYmOA@mail.gmail.com>
 <C787D2E8-6D03-4F4D-9633-2237AA0B2BE7@suse.de>
 <CAJhEC05hzf2zVyJabVExFNF0esiLovc+WLHOY_YhV22OUdGFZw@mail.gmail.com>
To: Robert Pang <robertpang@google.com>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>
X-Mailer: Apple Mail (2.3774.500.171.1.1)
X-Spam-Level: 
X-Spamd-Result: default: False [-3.60 / 50.00];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	BAYES_HAM(-0.59)[81.67%];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim];
	TO_DN_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: A1641206C0
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -3.60



> 2024=E5=B9=B44=E6=9C=8811=E6=97=A5 14:44=EF=BC=8CRobert Pang =
<robertpang@google.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> HI Coly
>=20
> Thank you for submitting it in the next merge window. This patch is
> very critical because the long IO stall measured in tens of seconds
> every hour is a serious issue making bcache unusable when it happens.
> So we look forward to this patch.
>=20
> Speaking of this GC issue, we gathered the bcache btree GC stats after
> our fio benchmark on a 375GB SSD cache device with 256kB bucket size:
>=20
> $ grep . =
/sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree_gc_*
> =
/sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree_gc_aver=
age_duration_ms:45293
> =
/sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree_gc_aver=
age_frequency_sec:286
> =
/sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree_gc_last=
_sec:212
> =
/sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree_gc_max_=
duration_ms:61986
> $ more =
/sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree_nodes
> 5876
>=20
> However, fio directly on the SSD device itself shows pretty good =
performance:
>=20
> Read IOPS 14,100 (110MiB/s)
> Write IOPS 42,200 (330MiB/s)
> Latency: 106.64 microseconds
>=20
> Can you shed some light on why CG takes so long (avg 45 seconds) given
> the SSD speed? And is there any way or setting to reduce the CG time
> or lower the GC frequency?
>=20
> One interesting thing we observed is when the SSD is encrypted via
> dm-crypt, the GC time is shortened ~80% to be under 10 seconds. Is it
> possible that GC writes the blocks one-by-one synchronously, and
> dm-crypt's internal queuing and buffering mitigates the GC IO latency?

Hi Robert,

Can I know In which kernel version did you test the patch?

I do a patch rebase and apply it on Linux v6.9. With a 4TB SSD as cache =
device, I didn=E2=80=99t observe obvious performance advantage of this =
patch.
And occasionally I a bit more GC time. It might be from my rebase =
modification in bch_btree_gc_finish(),
@@ -1769,6 +1771,11 @@ static void bch_btree_gc_finish(struct cache_set =
*c)
        c->gc_mark_valid =3D 1;
        c->need_gc      =3D 0;

+       ca =3D c->cache;
+       for_each_bucket(b, ca)
+               if (b->reclaimable_in_gc)
+                       b->reclaimable_in_gc =3D 0;
+
        for (i =3D 0; i < KEY_PTRS(&c->uuid_bucket); i++)
                SET_GC_MARK(PTR_BUCKET(c, &c->uuid_bucket, i),
                            GC_MARK_METADATA);

for_each_bucket() runs twice in bch_btree_gc_finish(). I guess maybe it =
is not exactly relevant to the GC time floating, but iterating all =
buckets twice in this patch looks a bit comfortable to me.


Hi Dongsheng,

Maybe my rebase is incorrect. Could you please post a new version which =
applies to the latest upstream bcache code?

Thanks in advance.


Coly Li


