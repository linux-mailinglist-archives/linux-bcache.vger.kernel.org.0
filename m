Return-Path: <linux-bcache+bounces-157-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 541B88181A3
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Dec 2023 07:42:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DA5FBB22F76
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Dec 2023 06:42:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B90A79D0;
	Tue, 19 Dec 2023 06:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1IxCNkDL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sxc+hESI";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1IxCNkDL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sxc+hESI"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F47C120
	for <linux-bcache@vger.kernel.org>; Tue, 19 Dec 2023 06:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 86946222CE;
	Tue, 19 Dec 2023 06:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1702968151; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LPWntze7fkx8IYXK0Z4eEB94xp0G+HivPyb3XZDiRMs=;
	b=1IxCNkDLs3o6En9n9HSmYBiD1v5CGkwpHl1JT77ShbeXCwQk8K1bPVw0ryyU5kHyt9YkGV
	IFSjeoH+acxs3HhuXhX5bGC8dYHpyc7bzP/mkeYcmO7ztFA/L784nUKsP7Ys2IKUk2LgMr
	5BzEgNAalsAKnr9Roqfr0O34Lsh39u0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1702968151;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LPWntze7fkx8IYXK0Z4eEB94xp0G+HivPyb3XZDiRMs=;
	b=sxc+hESIW9h8KRVjtIb5XSn4+uIQIvABzBZQzb+kxAYrobs12svq2l/hrSLLsvm+HUPxeN
	iovBzN7Lo7ilYCCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1702968151; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LPWntze7fkx8IYXK0Z4eEB94xp0G+HivPyb3XZDiRMs=;
	b=1IxCNkDLs3o6En9n9HSmYBiD1v5CGkwpHl1JT77ShbeXCwQk8K1bPVw0ryyU5kHyt9YkGV
	IFSjeoH+acxs3HhuXhX5bGC8dYHpyc7bzP/mkeYcmO7ztFA/L784nUKsP7Ys2IKUk2LgMr
	5BzEgNAalsAKnr9Roqfr0O34Lsh39u0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1702968151;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LPWntze7fkx8IYXK0Z4eEB94xp0G+HivPyb3XZDiRMs=;
	b=sxc+hESIW9h8KRVjtIb5XSn4+uIQIvABzBZQzb+kxAYrobs12svq2l/hrSLLsvm+HUPxeN
	iovBzN7Lo7ilYCCA==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 927FA1346B;
	Tue, 19 Dec 2023 06:42:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id kYZDEVY7gWVZeQAAn2gu4w
	(envelope-from <colyli@suse.de>); Tue, 19 Dec 2023 06:42:30 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.300.61.1.2\))
Subject: Re: bcache, possible to peg specific blocks to the cache drive?
From: Coly Li <colyli@suse.de>
In-Reply-To: <CAFkZcMzLpS=uJK-N2XGLBse1gec1CsR4-cBErZ9JdQCZvgxWSg@mail.gmail.com>
Date: Tue, 19 Dec 2023 14:42:17 +0800
Cc: Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0F9E4A9E-6F36-438E-B963-737B263DFB75@suse.de>
References: <CAFkZcMzLpS=uJK-N2XGLBse1gec1CsR4-cBErZ9JdQCZvgxWSg@mail.gmail.com>
To: N <dundir@gmail.com>
X-Mailer: Apple Mail (2.3774.300.61.1.2)
X-Spam-Level: ****
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Spamd-Bar: /
X-Spam-Flag: NO
X-Spamd-Result: default: False [0.11 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 BAYES_HAM(-1.08)[88.04%];
	 FROM_HAS_DN(0.00)[];
	 MV_CASE(0.50)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 MIME_GOOD(-0.10)[text/plain];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 RCPT_COUNT_TWO(0.00)[2];
	 TO_DN_ALL(0.00)[];
	 MX_GOOD(-0.01)[];
	 FREEMAIL_TO(0.00)[gmail.com];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 SUBJECT_ENDS_QUESTION(1.00)[];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1IxCNkDL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sxc+hESI
X-Spam-Score: 0.11
X-Rspamd-Queue-Id: 86946222CE



> 2023=E5=B9=B412=E6=9C=8819=E6=97=A5 06:44=EF=BC=8CN <dundir@gmail.com> =
=E5=86=99=E9=81=93=EF=BC=9A
>=20
> I asked in the IRC but didn't get an answer.
>=20
> I'm trying to find out how or if it might be possible to use the
> bcache module; and peg certain blocks/related files such that they
> will always be available from the cache?
>=20
> Usually its not much, but for example, with blocks related to boot
> files that may be invalidated fairly quickly under what would normally
> be heavier operating loads, this would be useful.

No we don=E2=80=99t support file level cache, and don=E2=80=99t pin =
specific block(s) in cache. And there is no plan to implement such =
mechanism.

Thanks.

Coly Li=

