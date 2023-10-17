Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB75E7CB76E
	for <lists+linux-bcache@lfdr.de>; Tue, 17 Oct 2023 02:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbjJQAdt (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 16 Oct 2023 20:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjJQAdt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 16 Oct 2023 20:33:49 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF740A7
        for <linux-bcache@vger.kernel.org>; Mon, 16 Oct 2023 17:33:46 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-5a86b6391e9so23018907b3.0
        for <linux-bcache@vger.kernel.org>; Mon, 16 Oct 2023 17:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google; t=1697502826; x=1698107626; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PeZYfupH65j4XqYoHlILg4MEJxVBWx2AELLnc/h6KbE=;
        b=DbpZPwj9RBt/9i06DiGDfrYpYSWBlXRc1UOFhrD7rLaGvuVTnCDqdC/+9fdEgZSFjM
         4uRb0CCWNRUSp6RmmY5uiPFWTSZSRGJNEo7bCnIalcSxtKgYGQ1pDpTsnmqWH4ZktHeB
         5nHJqGCzb0L1noZqgQ78P3BG0+WsPOLEqoIww=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697502826; x=1698107626;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PeZYfupH65j4XqYoHlILg4MEJxVBWx2AELLnc/h6KbE=;
        b=VzaIqhX1VYo0DbsZQtzN+fdPvyFtYWh5iuBhMOd9+SEpnLKgSukQBiPjvi8OzQQ/zW
         RX5WxEJUd/C0dUxhJAro22AJ2BZJgeir3Y6uBAJFINMK8Ax1TiBLKSFgGiszGoyRdUMb
         Cf8Uh2zV4qDb8LVvOJLaTpg1s2AF4xUXiRjqlmQMZchhkYHrFFzBVFfFviuzrdVd8TOL
         J+aw5TW2IEok6y4mHeeHNmmx/miEndmc/0LIDJBALkEL5jczJ3L5BWtH57WWswpFoVei
         CCrvRhqIFTwp4aKXI+qg77bHj5kzU09Tll3HPgOj8OZ4lRqBazvv+3o/2uWvHvjGYM63
         UVlg==
X-Gm-Message-State: AOJu0YyQ5i4+xUFHMMQFbbGePqnJKi4vWUVbu6IKBasG3+WYioitATi2
        BClH5zEATk678CtxXvo3QyZs66GUIv2g9FEKVskVfKPsnqjh98wF
X-Google-Smtp-Source: AGHT+IGpSzuvoJseg4qzhARZigpoE6Ee9eTzZM7WkhrNZ1sWNuqU5rIPN/Jngv4Duv8l6t5mEnhzcgc/EbE7Otcz/Ko=
X-Received: by 2002:a25:800a:0:b0:d9a:da03:2417 with SMTP id
 m10-20020a25800a000000b00d9ada032417mr546585ybk.45.1697502825995; Mon, 16 Oct
 2023 17:33:45 -0700 (PDT)
MIME-Version: 1.0
References: <7cadf9ff-b496-5567-9d60-f0af48122595@ewheeler.net>
 <AJUA3AAkJBN4GUdLmkiuQ4qP.3.1694501683518.Hmail.mingzhe.zou@easystack.cn>
 <f2fcf354-29ec-e2f7-b251-fb9b7d36f4@ewheeler.net> <CAC2ZOYti00duQqPJJqGm=GZRmH+X_uZW+V-WitvwP2s_12JGWA@mail.gmail.com>
 <87b4cac-6b15-14d9-7179-9becc24816d7@ewheeler.net>
In-Reply-To: <87b4cac-6b15-14d9-7179-9becc24816d7@ewheeler.net>
From:   Kai Krakow <kai@kaishome.de>
Date:   Tue, 17 Oct 2023 02:33:35 +0200
Message-ID: <CAC2ZOYsvAap_fb3E_XBUSUQY79vY+xuQCB2hipVfcCVSD74VMw@mail.gmail.com>
Subject: Re: Re: Dirty data loss after cache disk error recovery
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     =?UTF-8?B?6YK55piO5ZOy?= <mingzhe.zou@easystack.cn>,
        Coly Li <colyli@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        =?UTF-8?B?5ZC05pys5Y2/KOS6keahjOmdoiDnpo/lt54p?= 
        <wubenqing@ruijie.com.cn>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Am Di., 17. Okt. 2023 um 01:39 Uhr schrieb Eric Wheeler
<bcache@lists.ewheeler.net>:
>
> On Wed, 11 Oct 2023, Kai Krakow wrote:
> > After a reboot it worked again but of course there were still bad
> > blocks because bcache did writeback, so no blocks have been replaced
> > with btrfs auto-repair on read feature. This time, the system handled
> > the situation a bit better but files became inaccessible in the middle
> > of writing them which destroyed my Plasma desktop configuration and
> > Chrome profile (I restored them from the last snapper snapshot
> > successfully). Essentially, the file system was in a readonly-like
> > state: most requests failed with IO errors despite the btrfs didn't
> > switch to read-only. Something messed up in the error path of
> > userspace -> bcache -> btrfs -> device. Also, btrfs was seeing the
>
> Do you mean userspace -> btrfs -> bcache -> device

Ehm.. Yes...


> > device somewhere in the limbo of not existing and not working - it
> > still tried to access it while bcache claimed the backend device would
> > be missing. To me this looks like bcache error handling may need some
> > fine tuning - it should not fail in that way, especially not with
> > btrfs-raid, but still the system was seeing IO errors and broken files
> > in the middle of writes.
> >
> > "bcache show" showed the backend device missing while "btrfs dev show"
> > was still seeing the attached bcache device, and the system threw IO
> > errors to user-space despite btrfs still having a valid copy of the
> > blocks.
> >
> > I've rebooted and now switched the bad device from bcache writeback to
> > bcache none - and guess what: The system runs stable now, btrfs
> > auto-repair does its thing. The above mentioned behavior does not
> > occur (IO errors in user-space). A final scrub across the bad devices
> > repaired the bad blocks, I currently do not see any more problems.
> >
> > It's probably better to replace that device but this also shows that
> > switching bcache to "none" (if the backing device fails) or "write
> > through" at least may be a better choice than doing some other error
> > handling. Or bcache should have been able to make btrfs see the device
> > as missing (which obviously did not happen).
>
> Noted.  Did bcache actually detach its cache in the failure scenario
> you describe?

It seemed still attached but was marked as "missing" the the bcache cli tool.


> > Of course, if the cache device fails we have a completely different
> > situation. I'm not sure which situation Eric was seeing (I think the
> > caching device failed) but for me, the backing device failed - and
> > with bcache involved, the result was very unexpected.
>
> Ahh, so you are saying the cache continued to service requests even though
> the bdev was offline?  Was the bdev completely "unplugged" or was it just
> having IO errors?

smartctl was still seeing the device, so I think it "just" had IO errors.


> > So we probably need at least two error handlers: Handling caching
> > device errors, and handling backing device errors (for which bcache
> > doesn't currently seem to have a setting).
>
> I think it tries to write to the cache if the bdev dies.  Dirty or cached
> blocks are read from cache and other IOs are passed to bdev which may
> return end up returning an EIO.

Hmm, yes that makes sense... But it seems to confuse user-space a lot.

Except that in writeback mode, it won't (and cannot) return errors to
user-space although writes eventually fail later and data does not
persist. So it may be better to turn writeback off as soon as bdev IO
errors are found, or trigger an immediate writeback by temporarily
setting writeback_percent to 0. Usually, HDDs support self-healing -
which didn't work in this case because of delayed writeback. After I
switched to "none", it worked. After some more experimenting, it looks
like even "writethrough" may lack behind and not bubble bdev IO errors
back up to user-space (or it was due to writeback_percent=0, errors
are gone so I can no longer reproduce). I would expect it to do
exactly that, tho. I didn't test "writearound".

Also, it looks like a failed delay write from writeback dirty data may
not be retried by bcache. Or at least, I needed to run "btrfs scrub"
with bcache mode "none" to make it work properly and let the HDD heal
itself. OTOH, the HDD probably didn't fail writes but reads (except
when the situation got completely messed up and even writes returned
IO errors but maybe btrfs was involved here).

BTW: The failed HDDs ran fine for a few days now, even switched
writeback on again. It properly healed itself. But still, time to swap
it sooner than later.


>  Coly, is this correct?
>
> -Eric


Regards,
Kai
