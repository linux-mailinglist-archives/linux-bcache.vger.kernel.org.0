Return-Path: <linux-bcache+bounces-285-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 031B886F628
	for <lists+linux-bcache@lfdr.de>; Sun,  3 Mar 2024 17:36:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD0892813C2
	for <lists+linux-bcache@lfdr.de>; Sun,  3 Mar 2024 16:36:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E74D967E66;
	Sun,  3 Mar 2024 16:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OE8ufo24";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6ARhB7rq";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Qo+L9R0d";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="F4jwlyhU"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A895B66B5F;
	Sun,  3 Mar 2024 16:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709483772; cv=none; b=BP73X0ZB+OJycKgGFs0sxzJMoGhSHW/53JQg/8Nx+1zhk4eZXNUY9gS1oX+1ko7WYEXEoKOXo+bMj/jSFutnslbRCiZWS8gC5fBN6BRJJFuZgQ5kAIWRF+cIvHu0nW18zjhHOkOxnFCvYDQmOTZ6bZaSiQz3w1DIntjBZTnSP/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709483772; c=relaxed/simple;
	bh=V1jp6Q0+5Al40sK51AvrrksVYMlerOFrePkzcBGRqvg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=bhMnLqTNN8uJKkeqzXd1n1QRkySnQYmkYgufuS+OXkk6OK1kevo+cmOVM0Q0IIphs/c+mJSnsnb4hHZpExDQ5ZzeMsDo57/MrPLnKO3jX0wvqJNsC/3pZ39NMWM7QNsgcPGiSwxBgNmNTh6FiMSEZr8o9adCTyCIMPIddpAZmdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OE8ufo24; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6ARhB7rq; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Qo+L9R0d; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=F4jwlyhU; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CAD7B6110D;
	Sun,  3 Mar 2024 16:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1709483768; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3xRGC/2+ObQWup47//SiF+uS0L5aaXvlCZb7+ZZ9FkA=;
	b=OE8ufo24GaV4pzdiU7Vpa+qGyHoKF1RB0bQeQW9LKdY/8HX/ROdyuEo5M77a7emM84NLBP
	F/9/eXWzvm7OxSQkov2gYXUZNrcyVoV1giviF8PmfzwHjOFZzjjnRPXSngIlbbsu8OkpHH
	JCuhDV+XJv+6UGmyenjovYTjTkM+poo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1709483768;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3xRGC/2+ObQWup47//SiF+uS0L5aaXvlCZb7+ZZ9FkA=;
	b=6ARhB7rqoUyZUqcqw+RI/QCqnju3NNm9qqHQ2kkFtdLnMOw6l26jiRmJEoDCEepQBcI0jc
	qfnpyot62t1ALbDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1709483767; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3xRGC/2+ObQWup47//SiF+uS0L5aaXvlCZb7+ZZ9FkA=;
	b=Qo+L9R0dvmKbczskDm3NnFUXfE5R9s+DSoKUQdKTNVD+iaK3wQLkT+6bD0BRwd4v1Ail3y
	EOoRXt1N0wXpV/fberC9FB5tMKUVUH60rGSgJ18Upb3JLYgx8DR7D632HHK6c3RyKijPDF
	jYkNGNoFjcOoarpFifaqfFzWuHZJUgk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1709483767;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3xRGC/2+ObQWup47//SiF+uS0L5aaXvlCZb7+ZZ9FkA=;
	b=F4jwlyhUJtOGZCJwih7Hok2qd/H7vyLrKuoLfJ8awggXyrg0Snak+QZlLGRF3pS6lEkQQD
	Kk2UONKzDr9BHcCg==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id DBAD1133B5;
	Sun,  3 Mar 2024 16:36:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id DatMIvWm5GWpWAAAn2gu4w
	(envelope-from <colyli@suse.de>); Sun, 03 Mar 2024 16:36:05 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.300.61.1.2\))
Subject: Re: bcache queue limit cleanups
From: Coly Li <colyli@suse.de>
In-Reply-To: <20240303151250.GA27512@lst.de>
Date: Mon, 4 Mar 2024 00:35:48 +0800
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Jens Axboe <axboe@kernel.dk>,
 Bcache Linux <linux-bcache@vger.kernel.org>,
 Linux Block Devices <linux-block@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <228C3E27-8C94-417F-8269-1D8BA8C2CC8F@suse.de>
References: <20240226104826.283067-1-hch@lst.de>
 <20240303151250.GA27512@lst.de>
To: Christoph Hellwig <hch@lst.de>
X-Mailer: Apple Mail (2.3774.300.61.1.2)
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: ****
X-Spam-Score: 4.57
X-Spamd-Result: default: False [4.57 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 BAYES_HAM(-0.00)[36.12%];
	 FROM_HAS_DN(0.00)[];
	 MV_CASE(0.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_SPAM_SHORT(1.16)[0.388];
	 RCPT_COUNT_FIVE(0.00)[5];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 TO_DN_ALL(0.00)[];
	 NEURAL_SPAM_LONG(3.01)[0.860];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Flag: NO



> 2024=E5=B9=B43=E6=9C=883=E6=97=A5 23:12=EF=BC=8CChristoph Hellwig =
<hch@lst.de> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Mon, Feb 26, 2024 at 11:48:25AM +0100, Christoph Hellwig wrote:
>> this patch against Jens' for-6.9/block tree gets rid of the last
>> queue limit update in bcache by calculation the io_opt ahead of
>> time.
>=20
> Any chance to get this patch reviewed?  It is one of just two
> queue limits API parts that still isn't reviewed.
>=20
>=20

Done. Another patch was already in Jens=E2=80=99 tree, I guess it might =
be late to add my Reviewed-by.

Thanks.

Coly Li=

