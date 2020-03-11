Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C665A1815A7
	for <lists+linux-bcache@lfdr.de>; Wed, 11 Mar 2020 11:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgCKKUK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 11 Mar 2020 06:20:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50507 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgCKKUK (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 Mar 2020 06:20:10 -0400
Received: from 1.is.ballot.uk.vpn ([10.172.254.50])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <benjamin.allot@canonical.com>)
        id 1jByTA-0002zv-Su
        for linux-bcache@vger.kernel.org; Wed, 11 Mar 2020 10:20:08 +0000
To:     linux-bcache@vger.kernel.org
From:   Benjamin Allot <benjamin.allot@canonical.com>
Subject: [QUESTION] Bcache in writeback mode is bypassed
Message-ID: <abe94294-4365-6448-4c46-831c40d4d41d@canonical.com>
Date:   Wed, 11 Mar 2020 11:20:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello and sorry for the noise if this list is fully intended for contribution or patch purpose only.

We use bcache quite a lot on our infrastructure, and quite happily so far.
We recently noticed a strange behavior in the way bcache reports amount of dirty data and the related
available cache percentage used.

I opened a related "bug" [0] but I will do a quick TL;DR here

* bcache is in writeback mode, running, with one cache device, one backing device, writeback_percent set to 40

* bcache congested_{read,write}_threshold_us are set to 0

* writeback_rate_debug shows 148Gb of dirty data, priority_stats shows 70% of dirty data in the cache,
  the cache device is 1.6 TB (and the cache size related to that, given the nbbucket and bucket_size),
  so one of the metric is lying. Because we're at 70%, I believe we bypass the writeback
  completely because we reach CUTOFF_WRITEBACK_SYNC [1].

* As a result, on an I/O intensive throughput server, we have high I/O latency (=~ 1 sec) for both the cache device
  and the backing device (although I don't explain why we have this latency on the cache device as well. The graphs
  of both devices are pretty much aligned).

* when the GC is triggered (manually or automatically), the writeback is restored for a short period of
  time (10-15 minutes) and the I/O latency drops. Until we reach the 70% of dirty data mark again

* we seems to have this discrepancy of metric everywhere but because the default writeback_percent is at 10%, we
  never really reach the 70% threshold as displayed in priority_stats

Again sorry if this was the wrong forum.

Regards,

[0]: https://bugzilla.kernel.org/show_bug.cgi?id=206767
[1]: https://github.com/torvalds/linux/blob/v4.15/drivers/md/bcache/writeback.h line 69
