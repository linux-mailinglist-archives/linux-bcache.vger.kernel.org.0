Return-Path: <linux-bcache+bounces-260-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88C7B847FF1
	for <lists+linux-bcache@lfdr.de>; Sat,  3 Feb 2024 04:43:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38172289695
	for <lists+linux-bcache@lfdr.de>; Sat,  3 Feb 2024 03:43:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFD1BDF4A;
	Sat,  3 Feb 2024 03:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wcYtTLV/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3Lhwlf0w";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wcYtTLV/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3Lhwlf0w"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941B179FB
	for <linux-bcache@vger.kernel.org>; Sat,  3 Feb 2024 03:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706931825; cv=none; b=ZUC+YuH39k/oTWR1uOmz9Pl6svfvwNsf8yKWzy9TZAOxm28SVk6z5BPCg3jtg4FCpXkcE1GMIFSWr/nLMh4Ifu4Bx2/c+qHci9nIs5Yuj3RNSEFjCsh5owMQPoGzaxsBm2ePHILDYW/IpzqmgQL6RrWVCREjHzyQSCqkqFMzXlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706931825; c=relaxed/simple;
	bh=z4NAPrkfuuRozmbeXNw8Fwp7WeV16eZwNxA7KtS35PM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=LW8WULcdnE0/g9ANo/XBOcHaD/ykzCpqr9uIHbPwZR5GLBzR7moxjYjRpEYFuCncaMOnq2Hw75JnqRnEM+SnLrY4QMSWIe+GUtgttNKDbNtlqV3FvXnIOhkmOBiiIDcuV3V3GXtmWT/JRkM7oZMkGW+TUxSTBKtjWCRw4HWlano=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wcYtTLV/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3Lhwlf0w; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wcYtTLV/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3Lhwlf0w; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 25CA3339DF;
	Sat,  3 Feb 2024 03:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1706931820; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z4NAPrkfuuRozmbeXNw8Fwp7WeV16eZwNxA7KtS35PM=;
	b=wcYtTLV/FZkMb3dgE8JoepUR+PDiDzpB5H/VRH1SvWw/qQpnU5skrKiOFki8rm40qI7XAC
	YfmZ6BFQvjzXg0OBfHj//kTy8IYsoSbsbLRR73rxVNZCT5ceuKxLPqM++jCUB0ivokrNUL
	kw+OOd0BVUUgH3z5Qzo+gp34T+gfCB0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1706931820;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z4NAPrkfuuRozmbeXNw8Fwp7WeV16eZwNxA7KtS35PM=;
	b=3Lhwlf0wegaQKLKtSCO4u6oeRFNMpvZVNKoqKW3+WfsdJHqufsnY/dT3onGAmzOy5+ZGRI
	3mdhKaeWZ5PdZsCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1706931820; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z4NAPrkfuuRozmbeXNw8Fwp7WeV16eZwNxA7KtS35PM=;
	b=wcYtTLV/FZkMb3dgE8JoepUR+PDiDzpB5H/VRH1SvWw/qQpnU5skrKiOFki8rm40qI7XAC
	YfmZ6BFQvjzXg0OBfHj//kTy8IYsoSbsbLRR73rxVNZCT5ceuKxLPqM++jCUB0ivokrNUL
	kw+OOd0BVUUgH3z5Qzo+gp34T+gfCB0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1706931820;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z4NAPrkfuuRozmbeXNw8Fwp7WeV16eZwNxA7KtS35PM=;
	b=3Lhwlf0wegaQKLKtSCO4u6oeRFNMpvZVNKoqKW3+WfsdJHqufsnY/dT3onGAmzOy5+ZGRI
	3mdhKaeWZ5PdZsCg==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id F122913582;
	Sat,  3 Feb 2024 03:43:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id P0lgImq2vWWjQwAAn2gu4w
	(envelope-from <colyli@suse.de>); Sat, 03 Feb 2024 03:43:38 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.300.61.1.2\))
Subject: Re: I/O error on cache device can cause user observable errors
From: Coly Li <colyli@suse.de>
In-Reply-To: <CANF=pgrictityuTm4Uv_KqUn=LnbSf9VW7-EMYUS+MvCSdMqvQ@mail.gmail.com>
Date: Sat, 3 Feb 2024 11:43:24 +0800
Cc: Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E73B372A-F347-42A3-955E-A0DEA5B08C3E@suse.de>
References: <CANF=pgrX7h26TjA9bPUm9umRA-9KvELb9z3-bJsHm+t6SYbE1w@mail.gmail.com>
 <2944152A-ADF8-4B92-A9A2-D550BC51AF5E@suse.de>
 <CANF=pgrictityuTm4Uv_KqUn=LnbSf9VW7-EMYUS+MvCSdMqvQ@mail.gmail.com>
To: Arnaldo Montagner <armont@google.com>
X-Mailer: Apple Mail (2.3774.300.61.1.2)
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="wcYtTLV/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3Lhwlf0w
X-Spamd-Result: default: False [-1.74 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:98:from];
	 FROM_HAS_DN(0.00)[];
	 MV_CASE(0.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 BAYES_HAM(-1.93)[94.65%];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 RCPT_COUNT_TWO(0.00)[2];
	 TO_DN_ALL(0.00)[];
	 MX_GOOD(-0.01)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 25CA3339DF
X-Spam-Level: 
X-Spam-Score: -1.74
X-Spam-Flag: NO



> 2024=E5=B9=B42=E6=9C=883=E6=97=A5 01:48=EF=BC=8CArnaldo Montagner =
<armont@google.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Thanks for clarifying.
>=20
> Regarding the documentation, the first sentence in
> https://docs.kernel.org/admin-guide/bcache.html#error-handling says:
> "Bcache tries to transparently handle IO errors to/from the cache
> device without affecting normal operation"
>=20

Oh I see. This is for temporary I/O failure or error. If cache is clear =
and an I/O error encountered, bcache may fetch data from backing device.
Such operations are transparent to upper layer code.

> I guess I interpreted it in absolute terms, as some kind of guarantee
> that normal operation would not be affected.
>=20

For devices failure or absence, bcache need to make upper layer code to =
be aware and hand the aftermath when necessary. Your situation is in =
this category.

Thanks.

Coly Li=

