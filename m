Return-Path: <linux-bcache+bounces-288-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD47A87D177
	for <lists+linux-bcache@lfdr.de>; Fri, 15 Mar 2024 17:52:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 460221F23D67
	for <lists+linux-bcache@lfdr.de>; Fri, 15 Mar 2024 16:52:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEC1C3D96E;
	Fri, 15 Mar 2024 16:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DlGp9POM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kNht7jG6";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0lQmEzl3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6Nu+rPHy"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C350C2BD19;
	Fri, 15 Mar 2024 16:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710521566; cv=none; b=jbmnzHj3hM1/NncoosqBo1Ytyvd+jjOSi4VimSsj/FHZqwwfUFSBb2piCyuxGtyJanZ7NRGEa/ExbH8v7v1gPeZnFgPS+Gvmadc9fGQDmBTVEEzjn73PHRT/yBgntuBj4L8P0wIQZ/BI52Bh2cDVY3/FqefjnxAngm7sGSOr+9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710521566; c=relaxed/simple;
	bh=CciIwSuA7UZI/OKXgIghlzmwU2GKoq5+v7Qa7KRWjBc=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=H/cBfnzyKK52Pj6iZFBHs0ZX7VhyUh6BXCfq5PGRYddyp7G+A9P1kLwhA9wex3YA0iYyO1BTbWM99cxafl2Iqv/B2dIpXn1UIpvL4Pcb1ChjQLT3ERnkKBOdvRDw31IpgSpTU7cAMVdMxypVDh57CZt/+Ti8nVcGqzGVvenxG4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DlGp9POM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kNht7jG6; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0lQmEzl3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6Nu+rPHy; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DA45A1FB6E;
	Fri, 15 Mar 2024 16:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1710521563; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g3Rt5slZFDeq/B9WwKIzVVK+DOp1uUc4qBMUnC+v+KI=;
	b=DlGp9POMpftuWD9KdA2Yv63Rnh3/+/42iwHtAzJ/0mttptnJF0EDBWWjtqKCYwAEUZQs1z
	QeNCXzPhgiCxWCbXmIWYESfW+t+fTxcNrxNYzW3r3oXg+oxWZFRmkpn5mDzdc2loOZbfYc
	+RRkRHOcCh7P94GE3BPc8X/fwwYWSlc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1710521563;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g3Rt5slZFDeq/B9WwKIzVVK+DOp1uUc4qBMUnC+v+KI=;
	b=kNht7jG6YXK+KWgpxpogOfGN7ePW276zgAl5jt4KPJIQcPzMA8e6p5KxqiXz/pyP5zQLdi
	1+mFAI/Yz/qebCAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1710521562; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g3Rt5slZFDeq/B9WwKIzVVK+DOp1uUc4qBMUnC+v+KI=;
	b=0lQmEzl3oxDmtJxDbSJo5sKtYHL/BXNWU428lOoeZEfGq2HikXFtk08n9mqj61yExqsghp
	W00BpZxbMaI0Q/NGi65jEBjpRfcCJyXJ/BFWgTwKV9hqE6ttGKXWbZ47ycbkHEOwTxOOQi
	3o7ypfokMQbRO1Yf/d9AowC2ZySDVZ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1710521562;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g3Rt5slZFDeq/B9WwKIzVVK+DOp1uUc4qBMUnC+v+KI=;
	b=6Nu+rPHyn/u9urV6wUTbwMgjoyusYGJ2Z4BfDWm5POJBl8YAN4QpVyjIzwJQOLRPiQXVV4
	9Nrezs/beCw0zMBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 818CC1368C;
	Fri, 15 Mar 2024 16:52:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iAT/Cdh89GU9bwAAD6G6ig
	(envelope-from <colyli@suse.de>); Fri, 15 Mar 2024 16:52:40 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.400.31\))
Subject: Re: [PATCH] bcache: fix variable length array abuse in btree_iter
From: Coly Li <colyli@suse.de>
In-Reply-To: <20240315002129.18827-1-matthew@mm12.xyz>
Date: Sat, 16 Mar 2024 00:52:26 +0800
Cc: Bcache Linux <linux-bcache@vger.kernel.org>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <ABEE9BD9-9807-4D6F-AD4C-549A123109DE@suse.de>
References: <20240315002129.18827-1-matthew@mm12.xyz>
To: Matthew Mirvish <matthew@mm12.xyz>
X-Mailer: Apple Mail (2.3774.400.31)
X-Spam-Score: -1.85
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.85 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 BAYES_HAM(-0.84)[85.32%];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[3];
	 MV_CASE(0.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 TO_DN_SOME(0.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 NEURAL_HAM_SHORT(-0.20)[-0.976];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Level: 
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0lQmEzl3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6Nu+rPHy
X-Rspamd-Queue-Id: DA45A1FB6E



> 2024=E5=B9=B43=E6=9C=8815=E6=97=A5 08:21=EF=BC=8CMatthew Mirvish =
<matthew@mm12.xyz> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> btree_iter is used in two ways: either allocated on the stack with a
> fixed size MAX_BSETS, or from a mempool with a dynamic size based on =
the
> specific cache set. Previously, the struct had a fixed-length array of
> size MAX_BSETS which was indexed out-of-bounds for the =
dynamically-sized
> iterators, which causes UBSAN to complain.
>=20
> This patch uses the same approach as in bcachefs's sort_iter and =
splits
> the iterator into a btree_iter with a flexible array member and a
> btree_iter_stack which embeds a btree_iter as well as a fixed-length
> data array.
>=20
> Cc: stable@vger.kernel.org
> Closes: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2039368
> Signed-off-by: Matthew Mirvish <matthew@mm12.xyz>

This patch is overall good to me.
Let me take it and test for a while, and submit it to next merge window =
if the testing goes well.

Thanks.

Coly Li

> ---
> drivers/md/bcache/bset.c      | 44 +++++++++++++++++------------------
> drivers/md/bcache/bset.h      | 28 ++++++++++++++--------
> drivers/md/bcache/btree.c     | 40 ++++++++++++++++---------------
> drivers/md/bcache/super.c     |  5 ++--
> drivers/md/bcache/sysfs.c     |  2 +-
> drivers/md/bcache/writeback.c | 10 ++++----
> 6 files changed, 70 insertions(+), 59 deletions(-)
>=20

[snipped]


