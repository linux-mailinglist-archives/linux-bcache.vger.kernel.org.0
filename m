Return-Path: <linux-bcache+bounces-394-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2A8A89D401
	for <lists+linux-bcache@lfdr.de>; Tue,  9 Apr 2024 10:17:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FCA51C21EA9
	for <lists+linux-bcache@lfdr.de>; Tue,  9 Apr 2024 08:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC7FF7E574;
	Tue,  9 Apr 2024 08:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bCFKi5E3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1grhO2tR";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bCFKi5E3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1grhO2tR"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CE07E0FF;
	Tue,  9 Apr 2024 08:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712650664; cv=none; b=jatRflh7+897iGnr4b/mbHXpoDG0/HpLo9Bk+XPFdUIjGbkbGwLvH8IR49nDdzgrwxkfUnCocOPV3k3cQA+C4PMJLUA8+Q7Xxv5rVTYbKv0Rgrfzv4t3qoKF025O9OZVbo1/DyX6DbrfGQ8H60Xwr5jOWUnj4PqEoEj8933JljI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712650664; c=relaxed/simple;
	bh=AiFhZZUZqB6jjCLTAQDauhVTYjRmfj10W8hqnvzki7E=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=cdCssfdIhcbW9tmf8AtBeaULtlVfiqwYHKeiZL13hljOgm8NC3JGA+uFhStMsedmw0E2+C+pZE2CfG0jtcYyFEW+VwQTchQSB5jJlNyuNE9Yr0Sa1j7jBJxp+c54A96xc3US3U8xYdepTVAZ2MkhZDEsvlo2wrAE6b8IU9MdGaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bCFKi5E3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1grhO2tR; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bCFKi5E3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1grhO2tR; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 63E692089D;
	Tue,  9 Apr 2024 08:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1712650661; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AiFhZZUZqB6jjCLTAQDauhVTYjRmfj10W8hqnvzki7E=;
	b=bCFKi5E3op8vqPkRE5Sbt976rEx7PoAKBquyYapJgpO6sHmPOMPbigIrteb2mHDVxdnsBr
	wuhHZebZF4o7lZLq3nC7dYUJ5Z8v/HOEuH+gxLV9HM7QikbQtV9eiTvkbsy5gDQitRlBuE
	NNKJQomcOvD5NHxwcCnL6I3Fa0Ep3h0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1712650661;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AiFhZZUZqB6jjCLTAQDauhVTYjRmfj10W8hqnvzki7E=;
	b=1grhO2tRTMiz95IcoHP+oe+0Ibc+xLaBLrj2dYVbPsag9vxLnppOfoEEzTfy02DmkekeIB
	0r5f6bsqUpvWv1Bg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1712650661; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AiFhZZUZqB6jjCLTAQDauhVTYjRmfj10W8hqnvzki7E=;
	b=bCFKi5E3op8vqPkRE5Sbt976rEx7PoAKBquyYapJgpO6sHmPOMPbigIrteb2mHDVxdnsBr
	wuhHZebZF4o7lZLq3nC7dYUJ5Z8v/HOEuH+gxLV9HM7QikbQtV9eiTvkbsy5gDQitRlBuE
	NNKJQomcOvD5NHxwcCnL6I3Fa0Ep3h0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1712650661;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AiFhZZUZqB6jjCLTAQDauhVTYjRmfj10W8hqnvzki7E=;
	b=1grhO2tRTMiz95IcoHP+oe+0Ibc+xLaBLrj2dYVbPsag9vxLnppOfoEEzTfy02DmkekeIB
	0r5f6bsqUpvWv1Bg==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id C638713253;
	Tue,  9 Apr 2024 08:17:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id yQHPF5z5FGaONgAAn2gu4w
	(envelope-from <colyli@suse.de>); Tue, 09 Apr 2024 08:17:32 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH v3 00/17] treewide: Refactor heap related implementation
From: Coly Li <colyli@suse.de>
In-Reply-To: <i2qewo34mvw7bizhefwz5s3fc4nlc4zk7eijglkieuci5iradm@zgcks3u5omhw>
Date: Tue, 9 Apr 2024 16:17:14 +0800
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>,
 msakai@redhat.com,
 peterz@infradead.org,
 mingo@redhat.com,
 acme@kernel.org,
 namhyung@kernel.org,
 akpm@linux-foundation.org,
 bfoster@redhat.com,
 mark.rutland@arm.com,
 alexander.shishkin@linux.intel.com,
 jolsa@kernel.org,
 irogers@google.com,
 adrian.hunter@intel.com,
 jserv@ccns.ncku.edu.tw,
 Bcache Linux <linux-bcache@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 Linux bcachefs <linux-bcachefs@vger.kernel.org>,
 linux-perf-users@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8D0FD5AF-2AD9-4A91-831D-C79A798BED11@suse.de>
References: <20240406164727.577914-1-visitorckw@gmail.com>
 <i2qewo34mvw7bizhefwz5s3fc4nlc4zk7eijglkieuci5iradm@zgcks3u5omhw>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3774.500.171.1.1)
X-Spam-Flag: NO
X-Spam-Score: -1.58
X-Spam-Level: 
X-Spamd-Result: default: False [-1.58 / 50.00];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	BAYES_HAM(-0.78)[84.53%];
	MV_CASE(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,redhat.com,infradead.org,kernel.org,linux-foundation.org,arm.com,linux.intel.com,google.com,intel.com,ccns.ncku.edu.tw,vger.kernel.org,lists.linux.dev];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap2.dmz-prg2.suse.org:helo,imap2.dmz-prg2.suse.org:rdns]



> 2024=E5=B9=B44=E6=9C=889=E6=97=A5 11:40=EF=BC=8CKent Overstreet =
<kent.overstreet@linux.dev> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Sun, Apr 07, 2024 at 12:47:10AM +0800, Kuan-Wei Chiu wrote:
>> This patch series focuses on several adjustments related to heap
>> implementation. Firstly, a type-safe interface has been added to the
>> min_heap, along with the introduction of several new functions to
>> enhance its functionality. Additionally, the heap implementation for
>> bcache and bcachefs has been replaced with the generic min_heap
>> implementation from include/linux. Furthermore, several typos have =
been
>> corrected.
>>=20
>> Previous discussion with Kent Overstreet:
>> =
https://lkml.kernel.org/ioyfizrzq7w7mjrqcadtzsfgpuntowtjdw5pgn4qhvsdp4mqqg=
@nrlek5vmisbu
>>=20
>> Regards,
>> Kuan-Wei
>=20
> pointing test automation at it now:
> https://evilpiepirate.org/~testdashboard/ci?branch=3Drefactor-heap-v3
>=20
> Coli, could I get some acks from you?

Yes, the code tested and Acked-by sent.

Thanks.

Coly Li=

