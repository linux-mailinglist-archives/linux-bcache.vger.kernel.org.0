Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B93A7CB82C
	for <lists+linux-bcache@lfdr.de>; Tue, 17 Oct 2023 03:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbjJQB5v (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 16 Oct 2023 21:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234376AbjJQB5u (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 16 Oct 2023 21:57:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8442EA
        for <linux-bcache@vger.kernel.org>; Mon, 16 Oct 2023 18:57:46 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 23E3B1FEE8;
        Tue, 17 Oct 2023 01:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1697507865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AQyAcnSV8rv0BER/IFtbX9/QlWm3MsJ8m3dAGEU7aek=;
        b=n5LA1cxV2VJp2nW6HSqFboJiX/dQkcIpGVVh6E7GpA7+CPYppqILvcpExHAWgA/t5aHjxo
        oT1W1mj14rYfz0r4SKSOvBej+E7VGRqzHzSLVkd3LIhaNGIYHugcBmQG8B1i/1cjp0fIMP
        X0GwnP+voQXcWuD0zImRSdbH2rM23R4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1697507865;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AQyAcnSV8rv0BER/IFtbX9/QlWm3MsJ8m3dAGEU7aek=;
        b=O9DsI/Lo2Usna3FCi+mHpaXq9ptS0ERQCojH6M908xpdXpfiGXlkgPB//4CjKwlroAQ+/e
        /xFA4g/wKmpUvPAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7E2A91391B;
        Tue, 17 Oct 2023 01:57:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3FS9EhjqLWXdGgAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 17 Oct 2023 01:57:44 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.700.6\))
Subject: Re: Dirty data loss after cache disk error recovery
From:   Coly Li <colyli@suse.de>
In-Reply-To: <82A10A71B70FF2449A8AD233969A45A101CCE29C5B@FZEX5.ruijie.com.cn>
Date:   Tue, 17 Oct 2023 09:57:32 +0800
Cc:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <DD91DDDA-DA55-456A-B182-32A7EA7BE4A4@suse.de>
References: <82A10A71B70FF2449A8AD233969A45A101CCE29C5B@FZEX5.ruijie.com.cn>
To:     =?utf-8?B?IuWQtOacrOWNvyjkupHmoYzpnaIg56aP5beeKSI=?= 
        <wubenqing@ruijie.com.cn>
X-Mailer: Apple Mail (2.3731.700.6)
Authentication-Results: smtp-out2.suse.de;
        none
X-Spam-Level: 
X-Spam-Score: -3.66
X-Spamd-Result: default: False [-3.66 / 50.00];
         ARC_NA(0.00)[];
         TO_DN_EQ_ADDR_SOME(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         MV_CASE(0.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         BAYES_HAM(-0.06)[60.77%];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         RCPT_COUNT_TWO(0.00)[2];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         RCVD_TLS_ALL(0.00)[];
         MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2021=E5=B9=B44=E6=9C=8820=E6=97=A5 11:17=EF=BC=8C=E5=90=B4=E6=9C=AC=E5=8D=
=BF(=E4=BA=91=E6=A1=8C=E9=9D=A2 =E7=A6=8F=E5=B7=9E) =
<wubenqing@ruijie.com.cn> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi, Recently I found a problem in the process of using bcache. My =
cache disk was offline for some reasons. When the cache disk was back =
online, I found that the backend in the detached state. I tried to =
attach the backend to the bcache again, and found that the dirty data =
was lost. The md5 value of the same file on backend's filesystem is =
different because dirty data loss.
>=20
> I checked the log and found that logs:
> [12228.642630] bcache: conditional_stop_bcache_device() =
stop_when_cache_set_failed of bcache0 is "auto" and cache is dirty, stop =
it to avoid potential data corruption.
> [12228.644072] bcache: cached_dev_detach_finish() Caching disabled for =
sdb
> [12228.644352] bcache: cache_set_free() Cache set =
55b9112d-d52b-4e15-aa93-e7d5ccfcac37 unregistered

When you mention the bcache related issue, it would be better if the =
kernel version and distribution information are provided too. Some =
distributions don=E2=80=99t support bcache, it is possible that some =
necessary fixes are missed from backport for previous kernel version.

Thanks.

Coly Li

>=20
> I checked the code of bcache and found that a cache disk IO error will =
trigger __cache_set_unregister, which will cause the backend to be =
datach, which also causes the loss of dirty data. Because after the =
backend is reattached, the allocated bcache_device->id is incremented, =
and the bkey that points to the dirty data stores the old id.
>=20
> Is there a way to avoid this problem, such as providing users with =
options, if a cache disk error occurs, execute the stop process instead =
of detach.
> I tried to increase cache_set->io_error_limit, in order to win the =
time to execute stop cache_set.
> echo 4294967295 > =
/sys/fs/bcache/55b9112d-d52b-4e15-aa93-e7d5ccfcac37/io_error_limit
>=20
> It did not work at that time, because in addition to =
bch_count_io_errors, which calls bch_cache_set_error, there are other =
code paths that also call bch_cache_set_error. For example, an io error =
occurs in the journal:
> Apr 19 05:50:18 localhost.localdomain kernel: bcache: =
bch_cache_set_error() bcache: error on =
55b9112d-d52b-4e15-aa93-e7d5ccfcac37:=20
> Apr 19 05:50:18 localhost.localdomain kernel: journal io error
> Apr 19 05:50:18 localhost.localdomain kernel: bcache: =
bch_cache_set_error() , disabling caching
> Apr 19 05:50:18 localhost.localdomain kernel: bcache: =
conditional_stop_bcache_device() stop_when_cache_set_failed of bcache0 =
is "auto" and cache is dirty, stop it to avoid potential data =
corruption.
>=20
> When an error occurs in the cache device, why is it designed to =
unregister the cache_set? What is the original intention? The unregister =
operation means that all backend relationships are deleted, which will =
result in the loss of dirty data.
> Is it possible to provide users with a choice to stop the cache_set =
instead of unregistering it.

