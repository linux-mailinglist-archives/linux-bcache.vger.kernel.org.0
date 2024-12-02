Return-Path: <linux-bcache+bounces-815-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B6269E02E9
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Dec 2024 14:10:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8E57BB25524
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Dec 2024 11:58:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8A1E1FE465;
	Mon,  2 Dec 2024 11:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Vp4+FO7s";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="deubl0XG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Vp4+FO7s";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="deubl0XG"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB4D1FE460;
	Mon,  2 Dec 2024 11:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733140719; cv=none; b=gCnoFGqupNeHretfvjHGMtBue3IT6lK7cDHd0sF3N8MKJcT4ISYVci+s8OTILW+HQDGarH9nMG40oefi6VmzPG6dMyLXMzfUGn6LDvQE60Y8xmz+nsmxQHr3qMA+mHVhel8yCRJzVb5HOfJqN3hWOTNFWaj0oQOoer278/y2YRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733140719; c=relaxed/simple;
	bh=QMyq9EbEbrvn4BKynSCwBcST9IgH4SAAb9sn/izyyP4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Mn4nGdMSp5FsldnR1qbrwzgy5r3YdLmAfzqphHrXFfAPFQ8xVx7nsKMwrKVEBFIbXc6NvMs6tV4/0AuTSwqiFy0YYJXkq0btRh4BfXCNFmGj6AA0bdG73T/wZ9ONY+LVrPuE+zfjKDk1z8k8dG0gchgTzTeUP8G9v/dT7pS+k/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Vp4+FO7s; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=deubl0XG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Vp4+FO7s; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=deubl0XG; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 00D271F444;
	Mon,  2 Dec 2024 11:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733140716; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oYYrzFFBllny0Va36Wrisn0O7VuBee5DQnDnud69cTM=;
	b=Vp4+FO7sVlT/aGd3PpprDn34s8VqCEKsXyrC/QCr1lAqXz1aAmMhOfousGcjIkA+GNmZGV
	MR8wj8AByQLNX+7VqtrbMQr+5XSgFeQwkp7Rr3ntqyrwXzaBBc7hgjLvACRag1HnPXgzFv
	dXt+fZl/6tfl7mhqD7uY73LK68NC0+k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733140716;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oYYrzFFBllny0Va36Wrisn0O7VuBee5DQnDnud69cTM=;
	b=deubl0XGkcZCRMCbl08UHHNQ9+vlXd9ngoRdhhXOduoXkw7mU9Hdr4MbZQxkaZXhtMHzVT
	VXgswAUiR5Q8+yAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Vp4+FO7s;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=deubl0XG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1733140716; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oYYrzFFBllny0Va36Wrisn0O7VuBee5DQnDnud69cTM=;
	b=Vp4+FO7sVlT/aGd3PpprDn34s8VqCEKsXyrC/QCr1lAqXz1aAmMhOfousGcjIkA+GNmZGV
	MR8wj8AByQLNX+7VqtrbMQr+5XSgFeQwkp7Rr3ntqyrwXzaBBc7hgjLvACRag1HnPXgzFv
	dXt+fZl/6tfl7mhqD7uY73LK68NC0+k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1733140716;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oYYrzFFBllny0Va36Wrisn0O7VuBee5DQnDnud69cTM=;
	b=deubl0XGkcZCRMCbl08UHHNQ9+vlXd9ngoRdhhXOduoXkw7mU9Hdr4MbZQxkaZXhtMHzVT
	VXgswAUiR5Q8+yAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CB47913A31;
	Mon,  2 Dec 2024 11:58:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JDiRIemgTWdQbAAAD6G6ig
	(envelope-from <colyli@suse.de>); Mon, 02 Dec 2024 11:58:33 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH] bcache: revert replacing IS_ERR_OR_NULL with IS_ERR again
From: Coly Li <colyli@suse.de>
In-Reply-To: <20241202115638.28957-1-colyli@suse.de>
Date: Mon, 2 Dec 2024 19:58:21 +0800
Cc: linux-bcache@vger.kernel.org,
 linux-block@vger.kernel.org,
 Liequan Che <cheliequan@inspur.com>,
 stable@vger.kernel.org,
 Zheng Wang <zyytlz.wz@163.com>,
 Mingzhe Zou <mingzhe.zou@easystack.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1AE210DE-1BC5-4281-BD65-4748C11D9A71@suse.de>
References: <20241202115638.28957-1-colyli@suse.de>
To: axboe@kernel.dk
X-Mailer: Apple Mail (2.3826.200.121)
X-Rspamd-Queue-Id: 00D271F444
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_CC(0.00)[vger.kernel.org,inspur.com,163.com,easystack.cn];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_TRACE(0.00)[suse.de:+];
	FREEMAIL_ENVRCPT(0.00)[163.com];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	APPLE_MAILER_COMMON(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51
X-Spam-Flag: NO



> 2024=E5=B9=B412=E6=9C=882=E6=97=A5 19:56=EF=BC=8CColy Li =
<colyli@suse.de> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> From: Liequan Che <cheliequan@inspur.com>
>=20
> Commit 028ddcac477b ("bcache: Remove unnecessary NULL point check in
> node allocations") leads a NULL pointer deference in =
cache_set_flush().
>=20
> 1721         if (!IS_ERR_OR_NULL(c->root))
> 1722                 list_add(&c->root->list, &c->btree_cache);
>=20
> =46rom the above code in cache_set_flush(), if previous registration =
code
> fails before allocating c->root, it is possible c->root is NULL as =
what
> it is initialized. __bch_btree_node_alloc() never returns NULL but
> c->root is possible to be NULL at above line 1721.
>=20
> This patch replaces IS_ERR() by IS_ERR_OR_NULL() to fix this.
>=20
> Fixes: 028ddcac477b ("bcache: Remove unnecessary NULL point check in =
node allocations")
> Signed-off-by: Liequan Che <cheliequan@inspur.com>
> Cc: stable@vger.kernel.org
> Cc: Zheng Wang <zyytlz.wz@163.com>
> Reviewed-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
> drivers/md/bcache/super.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Hi Jens,

Could you please take this patch? It is tiny change but important, and =
good to have it in next rc release.

Thank you in advance.

Coly Li


