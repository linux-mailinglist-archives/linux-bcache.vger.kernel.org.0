Return-Path: <linux-bcache+bounces-822-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F1049E8554
	for <lists+linux-bcache@lfdr.de>; Sun,  8 Dec 2024 14:08:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C04F1642B6
	for <lists+linux-bcache@lfdr.de>; Sun,  8 Dec 2024 13:08:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE30514A098;
	Sun,  8 Dec 2024 13:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="skfPXcmn";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8js8Ky9K";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="skfPXcmn";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8js8Ky9K"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B489980BFF;
	Sun,  8 Dec 2024 13:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733663281; cv=none; b=LtE5yuh3qpSXNyQ1K75eQdVY7qEo3pwxRd6Bht35/ROzwbMnRwY+FujjJf+0+sfjExsV01fBAdY3OkC1aYysiSUMkkIpXso18QU6GP2BAtFkS/r5vTJpy0XMjHcsmeIlI7Ew+FWLp3o2qttoHZaj3OvP+zUNqoivtC55efn0DIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733663281; c=relaxed/simple;
	bh=9yQlwX99O0hoCN0qmx2ci3ptEE8fxP0Y9eFKYGdOmJ0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=fH6Aor9JmMdftuDZ2IbbvWTGJ2i9EuVvn0cjMjXw5uupXRZMHdF316NZrQworEXEIbf8W3KwV8l6ms7dpGjN9gpeFiuf6v9hGb0+ksU78vHnzjNf9ea87GezB7pgPt5QidIyvDXWp9LRkUHKt7/IhPJq28XtCYjIgpD4IwkzvCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=skfPXcmn; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8js8Ky9K; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=skfPXcmn; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8js8Ky9K; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 19C021F456;
	Sun,  8 Dec 2024 13:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733663271; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9yQlwX99O0hoCN0qmx2ci3ptEE8fxP0Y9eFKYGdOmJ0=;
	b=skfPXcmnj2Rhw52ucLZrl6rpJkIS5hJ51zQ1zpxsxLNAwXqXh+TtWxTlTCgwuRsyV4BiXm
	CXBAA6TrWtPltqwhErsFspFBJ6GlQxqX6+z/b/stoJpAyWyG8RXY2qf3e4ajgzLS1BqeJW
	qrxJeL7RUdnZMQCp+dgBggohQLNGzDs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733663271;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9yQlwX99O0hoCN0qmx2ci3ptEE8fxP0Y9eFKYGdOmJ0=;
	b=8js8Ky9Kwp48nZiOeTm/97hRO94mT9kfBpbC8BgQlwsOu/4eN0rzFrJOrzhh6v2l7PVx6H
	FzfTtpDy/RbqIFDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733663271; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9yQlwX99O0hoCN0qmx2ci3ptEE8fxP0Y9eFKYGdOmJ0=;
	b=skfPXcmnj2Rhw52ucLZrl6rpJkIS5hJ51zQ1zpxsxLNAwXqXh+TtWxTlTCgwuRsyV4BiXm
	CXBAA6TrWtPltqwhErsFspFBJ6GlQxqX6+z/b/stoJpAyWyG8RXY2qf3e4ajgzLS1BqeJW
	qrxJeL7RUdnZMQCp+dgBggohQLNGzDs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733663271;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9yQlwX99O0hoCN0qmx2ci3ptEE8fxP0Y9eFKYGdOmJ0=;
	b=8js8Ky9Kwp48nZiOeTm/97hRO94mT9kfBpbC8BgQlwsOu/4eN0rzFrJOrzhh6v2l7PVx6H
	FzfTtpDy/RbqIFDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F3069133D1;
	Sun,  8 Dec 2024 13:07:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id edYNKyWaVWcmewAAD6G6ig
	(envelope-from <colyli@suse.de>); Sun, 08 Dec 2024 13:07:49 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH] MAINTAINERS: update Coly Li's email address
From: Coly Li <colyli@suse.de>
In-Reply-To: <20241208115350.85103-1-colyli@kernel.org>
Date: Sun, 8 Dec 2024 21:07:33 +0800
Cc: linux-bcache@vger.kernel.org,
 linux-block@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E2D8F688-84F4-4F3C-BC94-D02BE988657E@suse.de>
References: <20241208115350.85103-1-colyli@kernel.org>
To: axboe@kernel.dk
X-Mailer: Apple Mail (2.3826.200.121)
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	APPLE_MAILER_COMMON(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid]
X-Spam-Flag: NO
X-Spam-Level: 

Hi Jens,

> 2024=E5=B9=B412=E6=9C=888=E6=97=A5 19:53=EF=BC=8Ccolyli@kernel.org =
=E5=86=99=E9=81=93=EF=BC=9A
>=20
> From: Coly Li <colyli@kernel.org>
>=20
> This patch updates Coly Li's email addres to colyli@kernel.org.
>=20
> Signed-off-by: Coly Li <colyli@kernel.org>
> ---
> MAINTAINERS | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS


I plan to switch to my kernel.org <http://kernel.org/> email account, =
could you please take this patch?

Thanks.

Coly Li


