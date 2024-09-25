Return-Path: <linux-bcache+bounces-737-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E6C169853AE
	for <lists+linux-bcache@lfdr.de>; Wed, 25 Sep 2024 09:20:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA6B9281008
	for <lists+linux-bcache@lfdr.de>; Wed, 25 Sep 2024 07:20:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2595D156C5F;
	Wed, 25 Sep 2024 07:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JC+KEUQv";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VzDHHtBw";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JC+KEUQv";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VzDHHtBw"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89061155C95;
	Wed, 25 Sep 2024 07:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727248821; cv=none; b=BInGBLPAS8ORRgk2Cq+4sJcWQamc+6SEHAXMih6vAorYHLDRnXgqD1ZIhlwFYuogc5Rm0S2jwq/1s2qxutCjgHry16xzA7LGFslcOS9RJ3Y38bBiGwLM8k99ue9iJo9UStgRxEHmbRuOeTXpf6RCq8Wy8ral3aeZYubfgAd8dcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727248821; c=relaxed/simple;
	bh=AUtjNNq0evqNjWtooVdnKEclfCGj01YVhm40ZRt3UsI=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=nr0vbqLh4+B4yJQ7XR3uJ//Hx3eqxC9hV8YXBPKoZC0obtWT4Lqy4qwH54KSh60yhPiAYPZZjQsZmr2gZGYQ7ezvk25iTRUmS+OFOXMrUUTkB97FaD7rmycG3DqWQlhlCPlzToU+aVyIItljhk5Jk6+7+fnJGNNcMHExBMqKfHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JC+KEUQv; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VzDHHtBw; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JC+KEUQv; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VzDHHtBw; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D13F9219C1;
	Wed, 25 Sep 2024 07:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727248811; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AUtjNNq0evqNjWtooVdnKEclfCGj01YVhm40ZRt3UsI=;
	b=JC+KEUQv/qXOtDfaSdMNyvTmiPMHN5etUXc5GxVbzpWqUXHOC/Yxm3m0oehFQz7wX7wDBP
	RSOmBOeSZ48o+VTcajn7FBRSKclgZMjnBqaBZ96PF7ahFECBfAiOQI/0XGKKn3sr86QEc4
	ZYrKEl47m06iVeWcSZ6ChSmtS4+rBNg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727248811;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AUtjNNq0evqNjWtooVdnKEclfCGj01YVhm40ZRt3UsI=;
	b=VzDHHtBw0x2bz4y1FrZ2FnIXaPqJC6j7hxpKpCBg0VW0DetHLV8cLM0XpZaQ9I/QzBBMFF
	oMoPCgxiyuwo77Cg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727248811; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AUtjNNq0evqNjWtooVdnKEclfCGj01YVhm40ZRt3UsI=;
	b=JC+KEUQv/qXOtDfaSdMNyvTmiPMHN5etUXc5GxVbzpWqUXHOC/Yxm3m0oehFQz7wX7wDBP
	RSOmBOeSZ48o+VTcajn7FBRSKclgZMjnBqaBZ96PF7ahFECBfAiOQI/0XGKKn3sr86QEc4
	ZYrKEl47m06iVeWcSZ6ChSmtS4+rBNg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727248811;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AUtjNNq0evqNjWtooVdnKEclfCGj01YVhm40ZRt3UsI=;
	b=VzDHHtBw0x2bz4y1FrZ2FnIXaPqJC6j7hxpKpCBg0VW0DetHLV8cLM0XpZaQ9I/QzBBMFF
	oMoPCgxiyuwo77Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AD21F13793;
	Wed, 25 Sep 2024 07:20:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AzeAGqi582YdbQAAD6G6ig
	(envelope-from <colyli@suse.de>); Wed, 25 Sep 2024 07:20:08 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH v1] md: Correct typos in multiple comments across various
 files
From: Coly Li <colyli@suse.de>
In-Reply-To: <CAPhsuW51S=WfyNoP_cWvNVq3rPW0+iBrhzRVaKK=q3PLRA94UA@mail.gmail.com>
Date: Wed, 25 Sep 2024 15:19:52 +0800
Cc: Shen Lichuan <shenlichuan@vivo.com>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Alasdair Kergon <agk@redhat.com>,
 snitzer@kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>,
 Bcache Linux <linux-bcache@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E9AFA16B-E8E4-4932-AC9F-A30BA1A8C924@suse.de>
References: <20240924091733.8370-1-shenlichuan@vivo.com>
 <d95d7419-7bac-802f-a5d6-456900539c32@redhat.com>
 <CAPhsuW51S=WfyNoP_cWvNVq3rPW0+iBrhzRVaKK=q3PLRA94UA@mail.gmail.com>
To: Song Liu <song@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>
X-Mailer: Apple Mail (2.3776.700.51)
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	APPLE_MAILER_COMMON(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid]
X-Spam-Flag: NO
X-Spam-Level: 



> 2024=E5=B9=B49=E6=9C=8825=E6=97=A5 05:24=EF=BC=8CSong Liu =
<song@kernel.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Mikulas,
>=20
> On Tue, Sep 24, 2024 at 6:30=E2=80=AFAM Mikulas Patocka =
<mpatocka@redhat.com> wrote:
>>=20
>> Hi
>>=20
>> I've applied the device mapper part of the patch.
>=20
> Would you mind taking the whole patch instead? You can add
>=20
> Acked-by: Song Liu <song@kernel.org>

Normally I don=E2=80=99t have interest for this type of patches, because =
it may introduce potential workload for downstream backport.

If this patch may go into upstream from other path, I don=E2=80=99t have =
objection neither. And if any comment wanted from me, I=E2=80=99d like =
to suggest to split this patch into multiple ones by different =
subsystem, it may be easier for downstream developers to do their =
backport.

Thanks.

Coly Li


