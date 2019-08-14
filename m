Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D93988D5DC
	for <lists+linux-bcache@lfdr.de>; Wed, 14 Aug 2019 16:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbfHNOXK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 14 Aug 2019 10:23:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40375 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfHNOXK (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 14 Aug 2019 10:23:10 -0400
Received: from mail-qk1-f200.google.com ([209.85.222.200])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <halves@canonical.com>)
        id 1hxuB9-0000Zc-IT
        for linux-bcache@vger.kernel.org; Wed, 14 Aug 2019 14:23:07 +0000
Received: by mail-qk1-f200.google.com with SMTP id o4so10811931qkg.11
        for <linux-bcache@vger.kernel.org>; Wed, 14 Aug 2019 07:23:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HyNOdgzrf0nEwWLN0ipEiO26i5YRDnxup2Cu8HuBZzY=;
        b=TJuha2U7aT6dYmljfauzW5rhB2qbPBjvOcml70V2KckdH+UD8FStdolmKmC25RNXLx
         M0dQBzX68WiGDvqQZUR63+Oi+6htqTkq7VqUctV+EBbm8mpL3UDmTzFDYGr97As5QMv5
         r9URNnpl30b6KV/OxSJpXua/XnZsXAQTvPo1jBPSuEK+KNyaiq173jO8X7yuM6BbcQMI
         e3mn4CZtZ0b7Bi/ixgkPtwzkV5eeAdd5Zx3XkGjTjK0lcVfS57V9coTLcnzm1QLa4E/6
         dX8ujAPC3Rt5yOM3mE+/5E3m/Z5uiiMqKG2QF+M6xm8BlGSsALtPqwfPwBOm8b+R8klx
         WiJw==
X-Gm-Message-State: APjAAAX4cy/X/g69l9dTPf9MIiu1RR6L816hnp+cCAf2kBUlLr89Mwvt
        pf7HB8nep47viy0XWB77TUOcnCYtpR2X6hoXSYLrZ2LaZWiNRINoNBIyPak4Tji4n2tuDcYIVuz
        n1rHuOglCyr38wZU1LeBv8d3ipWlpuywza1Si7TnXZw==
X-Received: by 2002:a37:9b82:: with SMTP id d124mr18216791qke.110.1565792586777;
        Wed, 14 Aug 2019 07:23:06 -0700 (PDT)
X-Google-Smtp-Source: APXvYqysQsjgJidhgsWx6K4OuqZYtSPysL0lhrpjw0CC5EWcGKlyOF9ztg1knSVFzSWIoV4eaLGtaQ==
X-Received: by 2002:a37:9b82:: with SMTP id d124mr18216773qke.110.1565792586594;
        Wed, 14 Aug 2019 07:23:06 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:4e3:83c1:584b:6fd:30f2:e7ed])
        by smtp.gmail.com with ESMTPSA id x26sm7928348qkn.116.2019.08.14.07.23.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 14 Aug 2019 07:23:05 -0700 (PDT)
From:   Heitor Alves de Siqueira <halves@canonical.com>
To:     colyli@suse.de
Cc:     kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, shile.zhang@linux.alibaba.com,
        vojtech@suse.com
Subject: Re: [PATCH] bcache: add cond_resched() in __bch_cache_cmp()
Date:   Wed, 14 Aug 2019 11:23:01 -0300
Message-Id: <20190814142301.32556-1-halves@canonical.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <c13b1d2a-a8e6-f20c-604e-a375c018bf66@suse.de>
References: <c13b1d2a-a8e6-f20c-604e-a375c018bf66@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,

We've had users impacted by system stalls and were able to trace it back to the
bcache priority_stats query. After investigating a bit further, it seems that
the sorting step in the quantiles calculation can cause heavy CPU
contention. This has a severe performance impact on any task that is running in
the same CPU as the sysfs query, and caused issues even for non-bcache
workloads.

We did some test runs with fio to get a better picture of the impact on
read/write workloads while a priority_stats query is running, and came up with
some interesting results. The bucket locking doesn't seem to have that
much performance impact even in full-write workloads, but the 'sort' can affect
bcache device throughput and latency pretty heavily (and any other tasks that
are "unlucky" to be scheduled together with it). In some of our tests, there was
a performance reduction of almost 90% in random read IOPS to the bcache device
(refer to the comparison graph at [0]). There's a few more details on the
Launchpad bug [1] we've created to track this, together with the complete fio
results + comparison graphs.

The cond_resched() patch suggested by Shile Zhang actually improved performance
a lot, and eliminated the stalls we've observed during the priority_stats
query. Even though it may cause the sysfs query to take a bit longer, it seems
like a decent tradeoff for general performance when running that query on a
system under heavy load. It's also a cheap short-term solution until we can look
into a more complex re-write of the priority_stats calculation (perhaps one that
doesn't require the locking?). Could we revisit Shile's patch, and consider
merging it?

Thanks!
Heitor

[0] https://people.canonical.com/~halves/priority_stats/read/4k-iops-2Dsmooth.png
[1] https://bugs.launchpad.net/bugs/1840043
