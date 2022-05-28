Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C5D536CD5
	for <lists+linux-bcache@lfdr.de>; Sat, 28 May 2022 14:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235398AbiE1MWc (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 28 May 2022 08:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349860AbiE1MWb (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 28 May 2022 08:22:31 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B16DFAD;
        Sat, 28 May 2022 05:22:29 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E43601F8A6;
        Sat, 28 May 2022 12:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653740547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aCH8j0YHe62GXQCXem5fPwISoS2mEFeSwQLpLjI+KLY=;
        b=KJr4aALjfLb+Zg72mA/q9maXwFmCOvALkGZaF0IE5EAy3FaiqwCOu35mqudOSjEgjtOVYE
        SxHaZOBQMB2dDpBT1gYamI18pIn0AGoGTlG4G+gfYqRB0STLzbk/T6xTFL29S6oW/l8FKI
        BLFhKOAXC5u/MeSMlBif0pvh2oVpdzs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653740547;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aCH8j0YHe62GXQCXem5fPwISoS2mEFeSwQLpLjI+KLY=;
        b=1NPcpB1bScck960d8ZCM2WBUgkUvp3nnV7oXmpiX2GHGsM/bfd7WMhiAvLh9u+DDIn5XbK
        QekGgrkFGjiyKhCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 298B4134B3;
        Sat, 28 May 2022 12:22:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /G4YOgIUkmJkHwAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 28 May 2022 12:22:26 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH 1/1] bcache: avoid unnecessary soft lockup in kworker
 update_writeback_rate()
From:   Coly Li <colyli@suse.de>
In-Reply-To: <8a45c9fa-4cd8-e0e0-63f3-03adb761f9ca@kernel.dk>
Date:   Sat, 28 May 2022 20:22:24 +0800
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1BD307CE-9390-4A4B-B917-676104DA77F1@suse.de>
References: <20220528061949.28519-1-colyli@suse.de>
 <20220528061949.28519-2-colyli@suse.de>
 <8a45c9fa-4cd8-e0e0-63f3-03adb761f9ca@kernel.dk>
To:     Jens Axboe <axboe@kernel.dk>
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B45=E6=9C=8828=E6=97=A5 20:20=EF=BC=8CJens Axboe =
<axboe@kernel.dk> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 5/28/22 12:19 AM, Coly Li wrote:
>> The kworker routine update_writeback_rate() is schedued to update the
>> writeback rate in every 5 seconds by default. Before calling
>> __update_writeback_rate() to do real job, semaphore =
dc->writeback_lock
>> should be held by the kworker routine.
>>=20
>> At the same time, bcache writeback thread routine =
bch_writeback_thread()
>> also needs to hold dc->writeback_lock before flushing dirty data back
>> into the backing device. If the dirty data set is large, it might be
>> very long time for bch_writeback_thread() to scan all dirty buckets =
and
>> releases dc->writeback_lock. In such case update_writeback_rate() can =
be
>> starved for long enough time so that kernel reports a soft lockup =
warn-
>> ing started like:
>>  watchdog: BUG: soft lockup - CPU#246 stuck for 23s! =
[kworker/246:31:179713]
>>=20
>> Such soft lockup condition is unnecessary, because after the =
writeback
>> thread finishes its job and releases dc->writeback_lock, the kworker
>> update_writeback_rate() may continue to work and everything is fine
>> indeed.
>>=20
>> This patch avoids the unnecessary soft lockup by the following =
method,
>> - Add new member to struct cached_dev
>>  - dc->rate_update_retry (0 by default)
>> - In update_writeback_rate() call =
down_read_trylock(&dc->writeback_lock)
>>  firstly, if it fails then lock contention happens.
>> - If dc->rate_update_retry <=3D BCH_WBRATE_UPDATE_RETRY_MAX (15), =
doesn't
>>  acquire the lock and reschedules the kworker for next try.
>> - If dc->rate_update_retry > BCH_WBRATE_UPDATE_RETRY_MAX, no retry
>>  anymore and call down_read(&dc->writeback_lock) to wait for the =
lock.
>>=20
>> By the above method, at worst case update_writeback_rate() may retry =
for
>> 1+ minutes before blocking on dc->writeback_lock by calling =
down_read().
>> For a 4TB cache device with 1TB dirty data, 90%+ of the unnecessary =
soft
>> lockup warning message can be avoided.
>>=20
>> When retrying to acquire dc->writeback_lock in =
update_writeback_rate(),
>> of course the writeback rate cannot be updated. It is fair, because =
when
>> the kworker is blocked on the lock contention of dc->writeback_lock, =
the
>> writeback rate cannot be updated neither.
>>=20
>> This change follows Jens Axboe's suggestion to a more clear and =
simple
>> version.
>=20
> This looks fine, but it doesn't apply to my current for-5.19/drivers
> branch which the previous ones did. Did you spin this one without the
> other patches, perhaps?
>=20
> One minor thing we might want to change if you're respinning it -
> BCH_WBRATE_UPDATE_RETRY_MAX isn't really named for what it does, since
> it doesn't retry anything, it simply allows updates to be skipped. Why
> not call it BCH_WBRATE_UPDATE_MAX_SKIPS instead? I think that'd be
> better convey what it does.

Naming is often challenge for me. Sure, _MAX_SKIPS is better. I will =
post another modified version.

Thanks for the suggestion.

Coly Li

