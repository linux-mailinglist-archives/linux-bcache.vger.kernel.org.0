Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4161FBD70
	for <lists+linux-bcache@lfdr.de>; Tue, 16 Jun 2020 20:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731039AbgFPSAm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 16 Jun 2020 14:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbgFPSAm (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 16 Jun 2020 14:00:42 -0400
X-Greylist: delayed 394 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 16 Jun 2020 11:00:41 PDT
Received: from smtp.mfedv.net (smtp.mfedv.net [IPv6:2a04:6c0:2::19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4390C061573
        for <linux-bcache@vger.kernel.org>; Tue, 16 Jun 2020 11:00:41 -0700 (PDT)
Received: from suse92host.mfedv.net (suse92host.mfedv.net [IPv6:2a04:6c0:2:3:0:0:0:ffff])
        by smtp.mfedv.net (8.15.2/8.15.2/Debian-10) with ESMTP id 05GHs31x006775;
        Tue, 16 Jun 2020 17:54:04 GMT
Received: from xoff (klappe2.mfedv.net [192.168.71.72])
        by suse92host.mfedv.net (Postfix) with SMTP id 4D058C89D1;
        Tue, 16 Jun 2020 19:54:03 +0200 (CEST)
        (envelope-from mf@mferd.de)
Date:   Tue, 16 Jun 2020 19:54:03 +0200
From:   Matthias Ferdinand <mf@mferd.de>
To:     Marc Smith <msmith626@gmail.com>
Cc:     linux-bcache@vger.kernel.org
Subject: Re: Small Cache Dev Tuning
Message-ID: <20200616175403.GB626279@xoff>
References: <CAH6h+hcikX895gU2mGC05MTw7BCdV+kPeqGgrSRPwKXe1hjw+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAH6h+hcikX895gU2mGC05MTw7BCdV+kPeqGgrSRPwKXe1hjw+g@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Jun 16, 2020 at 10:57:43AM -0400, Marc Smith wrote:
> This certainly helps me allow more dirty data than what the defaults
> are set to.

I only have production experience with slightly older kernels (4.15) and
~40GB partition of an Intel DC SATA SSD (XFS fs). Average latency of the
bcache device improved a lot with _reduced_ writeback_percent. I guess
dirty block bookkeeping adds its own I/O.
Currently I run them even at writeback_percent=1.

Not exactly answering your question, though :-)

Matthias


 But a couple other followup questions:
> - Any additional recommended tuning/settings for small cache devices?
> - Is the soft threshold for dirty writeback data 70% so there is
> always room for metadata on the cache device? Dangerous to try and
> recompile with larger maximums?
> - I'm still studying the code, but so far I don't see this, and wanted
> to confirm that: The writeback thread doesn't look at congestion on
> the backing device when flushing out data (and say pausing the
> writeback thread as needed)? For spinning media, if lots of latency
> sensitive reads are going directly to the backing device, and we're
> flushing a lot of data from cache to backing, that hurts.
> 
> 
> Thanks,
> 
> Marc
