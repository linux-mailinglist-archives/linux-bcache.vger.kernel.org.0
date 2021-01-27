Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69536305D11
	for <lists+linux-bcache@lfdr.de>; Wed, 27 Jan 2021 14:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238405AbhA0N0b (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 27 Jan 2021 08:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238152AbhA0NYp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 Jan 2021 08:24:45 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9752C06174A
        for <linux-bcache@vger.kernel.org>; Wed, 27 Jan 2021 05:24:04 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id bl23so2633391ejb.5
        for <linux-bcache@vger.kernel.org>; Wed, 27 Jan 2021 05:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZXRrBYbJxZYLP86SDYZTAje+pNzxmGuRade79SdAr7c=;
        b=mqB9/OVK8yG6IvR4sVgYKFYLqSeHF8VSYiJz5i9MsOEQ+/zHqi7faqVgJkiam7hcVL
         4uJo5+Dsq2N8ptVnTnAva83Cy8PhQAI9HnqsP+wvyfPPEb8R65S3CJmDLMIZVljYtSi3
         vN8Ldg452hcLBqrWcBCpjlJd2OObi69yX+5D4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZXRrBYbJxZYLP86SDYZTAje+pNzxmGuRade79SdAr7c=;
        b=HxKYPkaDwy+H7KNc0njeW5KyEGcy0KbuG1ir9helRLzwrJh9FfuG2xdYrX2Kj3PIj1
         jAgD5D9YLMDO4rCsmCfSpamXGk+JCpPeMXMqpXW7cT4NMT3ISTke1L8OSYlC1UPtzEd6
         W44iX7jAsAUclnmevAm99+SqDWdJ8HAm7PnTw//yAbOGaefNSsHiyOTtIej+jwkHEidT
         pOPJSNvAXVpb7zEERrSncTggUHsqQ9oBUuo1BgRMBUch3UpBpOi6zicMZaWuscceJBlD
         70Xw8EnOGPloMKp3fpwHhUY23lqgqWGKOKQmH6drtBGvODt4ymV5Sn5IoxRdcpo2qfkG
         Deqg==
X-Gm-Message-State: AOAM531enxETQ6YHkpXfkK1NoF6U9PJGe7NEuXTFnob40nHw2QW2slsa
        H+OrWlBKVsM6VVLO8DWLVsL1e2sGmqco8g==
X-Google-Smtp-Source: ABdhPJy783FC1PkEEElAzqZqr6wr/HfiAdNnwboNmHqjSBlNM14ud4pDlLhWWJG7u3Jv5jqW2Vqp4A==
X-Received: by 2002:a17:906:5fc6:: with SMTP id k6mr7083484ejv.252.1611753843144;
        Wed, 27 Jan 2021 05:24:03 -0800 (PST)
Received: from jupiter.sol.kaishome.de ([2a02:8109:c40:9200::1a2])
        by smtp.gmail.com with ESMTPSA id h16sm1323990edw.34.2021.01.27.05.24.01
        for <linux-bcache@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 05:24:02 -0800 (PST)
Received: (nullmailer pid 558026 invoked by uid 500);
        Wed, 27 Jan 2021 13:24:01 -0000
From:   Kai Krakow <kai@kaishome.de>
To:     linux-bcache@vger.kernel.org
Subject: Fix degraded system performance due to workqueue overload
Date:   Wed, 27 Jan 2021 14:23:48 +0100
Message-Id: <20210127132350.557935-1-kai@kaishome.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In the past months (and looking back, even years), I was seeing system
performance and latency degrading vastly when bcache is active.

Finally, with kernel 5.10, I was able to locate the problem:

[250336.887598] BUG: workqueue lockup - pool cpus=2 node=0 flags=0x0 nice=0 stuck for 72s!
[250336.887606] Showing busy workqueues and worker pools:
[250336.887607] workqueue events: flags=0x0
[250336.887608]   pwq 10: cpus=5 node=0 flags=0x0 nice=0 active=3/256 refcnt=4
[250336.887611]     pending: psi_avgs_work, psi_avgs_work, psi_avgs_work
[250336.887619]   pwq 4: cpus=2 node=0 flags=0x0 nice=0 active=15/256 refcnt=16
[250336.887621]     in-flight: 3760137:psi_avgs_work
[250336.887624]     pending: psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work, psi_avgs_work
[250336.887637]   pwq 0: cpus=0 node=0 flags=0x0 nice=0 active=1/256 refcnt=2
[250336.887639]     pending: psi_avgs_work
[250336.887643] workqueue events_power_efficient: flags=0x80
[250336.887644]   pwq 4: cpus=2 node=0 flags=0x0 nice=0 active=1/256 refcnt=2
[250336.887646]     pending: do_cache_clean
[250336.887651] workqueue mm_percpu_wq: flags=0x8
[250336.887651]   pwq 4: cpus=2 node=0 flags=0x0 nice=0 active=2/256 refcnt=4
[250336.887653]     pending: lru_add_drain_per_cpu BAR(60), vmstat_update
[250336.887666] workqueue bcache: flags=0x8
[250336.887667]   pwq 4: cpus=2 node=0 flags=0x0 nice=0 active=1/256 refcnt=2
[250336.887668]     pending: cached_dev_nodata
[250336.887681] pool 4: cpus=2 node=0 flags=0x0 nice=0 hung=72s workers=2 idle: 3760136

I was able to track that back to the following commit:
56b30770b27d54d68ad51eccc6d888282b568cee ("bcache: Kill btree_io_wq")

Reverting that commit (with some adjustments due to later code changes)
improved my desktop latency a lot, I mean really a lot. The system was
finally able to handle somewhat higher loads without stalling for
several seconds and without spiking load into the hundreds while doing a
lot of write IO.

So I dug a little deeper and found that the assumption of this old
commit may no longer be true and bcache simply overwhelms the system_wq
with too many or too long running workers. This should really only be
used for workers that can do their work almost instantly, and it should
not be spammed with a lot of workers which bcache seems to do (look at
how many kthreads it creates from workers):

# ps aux | grep 'kworker/.*bc' | wc -l
131

And this is with a mostly idle system, it may easily reach 700+. Also,
with my patches in place, that number seems to be overall lower.

So I added another commit (patch 2) to move another worker queue over
to a dedicated worker queue ("bcache: Move journal work to new
background wq").

I tested this by overloading my desktop system with the following
parallel load:

  * A big download at 1 Gbit/s, resulting in 60+ MB/s write
  * Active IPFS daemon
  * Watching a YouTube video
  * Fully syncing 4 IMAP accounts with MailSpring
  * Running a Gentoo system update (compiling packages)
  * Browsing the web
  * Running a Windows VM (Qemu) with Outlook and defragmentation
  * Starting and closing several applications and clicking in them

IO setup: 4x HDD (2+2+4+4 TB) btrfs RAID-0 with 850 GB SSD bcache
Kernel 5.10.10

Without the patches, the system would have come to a stop, probably not
recovering from it (last time I tried, a clean shutdown took 1+ hour).
With the patches, the system easily survives and feels overall smooth
with only a small perceivable lag.

Boot times are more consistent, too, and faster when bcache is mostly
cold due to a previous system update.

Write rates of the system are more smooth now, and can easily sustain a
constant load of 200-300 MB/s while previously I would see long stalls
followed by vastly reduces write performance (down to 5-20 MB/s).

I'm not sure if there are side-effects of my patches that I cannot know
of but it works great for me: All write-related desktop stalling is
gone.

-- 
Regards,
Kai


