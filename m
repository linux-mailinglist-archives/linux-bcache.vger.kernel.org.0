Return-Path: <linux-bcache+bounces-785-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9211B9C717C
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Nov 2024 14:55:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48ECB1F21E9A
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Nov 2024 13:55:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8029201264;
	Wed, 13 Nov 2024 13:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dqnu2gc0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="P7vpyCHz";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wEBQtJfZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wOPMT26V"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF02C201024;
	Wed, 13 Nov 2024 13:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731506045; cv=none; b=Oj1l0HDgsAHCgU7gU2OAt6uEfzYwpSAkHNplUVOyBjO0NbBTjbGZBtJ2b6lWrbbrLOpH7nwRrIO0w9kkzUty3GhM/Ep2+zcq4C0X49S93Z8q2gm0MImBs1aj+ZHP1npPZgLbj6ZyDjkzYxS0Ce6pKVUwUAaJw+itO/CJCzxUxmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731506045; c=relaxed/simple;
	bh=WH4jYiT5LUke4xRl6xPxpGeYAxxej/srNNPCvsOz+2Y=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=hjhwWlSdkMfNDmEf2Zin12V06I2SdTAdbcsvc1YiV505B92/lYJTk3FLpqkYRa9Thj+Veb6x3IJLhprd+qGe9YnP342xQQfiyySZU83L1sAZWmcKZMF2n+jwREvXHGJ07L2r6IFCNl/Y7wlFg7oy3TQgTd9YoM54B45eozw1XVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dqnu2gc0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=P7vpyCHz; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wEBQtJfZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wOPMT26V; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DA54A1F37C;
	Wed, 13 Nov 2024 13:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1731506042; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WH4jYiT5LUke4xRl6xPxpGeYAxxej/srNNPCvsOz+2Y=;
	b=dqnu2gc0vasSQtQIwnXrAXWFsqxz+QU/UsvvTrFTh81ZtruNOkIHWDBjKy7dtxelI03Auq
	tPWqE2b8/e13LBV3DYBLGZTcX2NgmzqeNBtKExUgkuhQuT91uBptsE3ODtfij50jMPVjAn
	gypFrnPyIMEni7RFLeTfs6jI4lt7kL4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1731506042;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WH4jYiT5LUke4xRl6xPxpGeYAxxej/srNNPCvsOz+2Y=;
	b=P7vpyCHz1k2ztmZI47CeLbk93BSSUjGzNyQrxfhDDn77k10CLR9tWxav63mBmuQOoukRO3
	A8erl4jctYSRdEAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1731506041; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WH4jYiT5LUke4xRl6xPxpGeYAxxej/srNNPCvsOz+2Y=;
	b=wEBQtJfZxqeUC3fw4m1AcSwscuNwBXuxTmOU7FtC3phLVziYWqrdJSCoicAb+ze31k1ikF
	ft0jneB9F9uRjYbCFR32G5PP2SDf1VXiMLLjwm/iVT9CekKMFZLq+zOAK4gn7wFRWT5HNt
	b+sJw2hfB3shYCm+xKVNZcZXQqQ4uU8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1731506041;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WH4jYiT5LUke4xRl6xPxpGeYAxxej/srNNPCvsOz+2Y=;
	b=wOPMT26VwAsCPhugyEVx809HrQ+9BmmuM9kKj86p6zKsGblO00afbvUgp2VuirEQrNMSkl
	i8C0isFjuUW1XiAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DD11513A6E;
	Wed, 13 Nov 2024 13:53:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vYebInevNGfdYgAAD6G6ig
	(envelope-from <colyli@suse.de>); Wed, 13 Nov 2024 13:53:59 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: bcache: fix oops bug in cache_set_flush
From: Coly Li <colyli@suse.de>
In-Reply-To: <TYZPR02MB78424F31FF023102693D2DB2A65A2@TYZPR02MB7842.apcprd02.prod.outlook.com>
Date: Wed, 13 Nov 2024 21:53:38 +0800
Cc: Kent Overstreet <kent.overstreet@gmail.com>,
 linux-bcache <linux-bcache@vger.kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <15077D4C-8DE9-4751-9492-51D972B3E4C3@suse.de>
References: <CAAsfc_omvbgaSpmxqPPD9Jf4P2H-fEU97ADfRzJ0jULxGJehwg@mail.gmail.com>
 <TYZPR02MB78424F31FF023102693D2DB2A65A2@TYZPR02MB7842.apcprd02.prod.outlook.com>
To: "mingzhe.zou@easystack.cn" <mingzhe.zou@easystack.cn>,
 liequan che <liequanche@gmail.com>
X-Mailer: Apple Mail (2.3826.200.121)
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_TO(0.00)[easystack.cn,gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	APPLE_MAILER_COMMON(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid]
X-Spam-Score: -2.80
X-Spam-Flag: NO



> 2024=E5=B9=B411=E6=9C=8813=E6=97=A5 16:58=EF=BC=8Cmingzhe.zou@easystack.=
cn =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi, cheliequan and Coly:
>=20
> I saw some dmesg printing information from =
https://gitee.com/openeuler/kernel/issues/IB3YQZ
>=20

This is a distribution issue, not upstream bug.

The kernel is based on 5.10 kernel. If it can be confirmed to reproduce =
with latest upstream kernel, I can take a look.

Thanks.

Coly Li
>=20
>=20

[snipped]


