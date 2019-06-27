Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCC3F582AC
	for <lists+linux-bcache@lfdr.de>; Thu, 27 Jun 2019 14:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfF0Mef (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 27 Jun 2019 08:34:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:36648 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726059AbfF0Mef (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 27 Jun 2019 08:34:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2587BAE8B;
        Thu, 27 Jun 2019 12:34:34 +0000 (UTC)
Received: from shadow.suse.cz (shadow.suse.cz [10.100.13.111])
        by dark.suse.cz (Postfix) with ESMTP id 7342212CC0A;
        Thu, 27 Jun 2019 14:34:33 +0200 (CEST)
Received: by shadow.suse.cz (Postfix, from userid 10002)
        id 4292144940; Thu, 27 Jun 2019 14:34:33 +0200 (CEST)
Date:   Thu, 27 Jun 2019 14:34:33 +0200
From:   Vojtech Pavlik <vojtech@suse.com>
To:     Coly Li <colyli@suse.de>
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        Marc Smith <msmith626@gmail.com>, linux-bcache@vger.kernel.org
Subject: Re: I/O Reordering: Cache -> Backing Device
Message-ID: <20190627123433.GA15646@suse.cz>
References: <CAH6h+hd5qZdosqavv_ABHKAgRviUidxH_s3HZtLz5Fntg4Y3+A@mail.gmail.com>
 <alpine.LRH.2.11.1906260001290.1114@mx.ewheeler.net>
 <10bdb5ec-ca74-33f9-7482-fa53046d51b9@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10bdb5ec-ca74-33f9-7482-fa53046d51b9@suse.de>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Jun 27, 2019 at 08:13:57PM +0800, Coly Li wrote:

> > Do you know how the nr_stripes, stripe_sectors_dirty and 
> > full_dirty_stripes bitmaps work together to make a best-effort of writing 
> > full stripes to the disk, and maybe you can explain under what 
> > circumstances partial stripes would be written?
> Hi Eric,
> 
> I don't have satisfied answer to the above question. But if upper layers
> don't issue I/Os with full stripe aligned, bcache cannot do anything
> more than merging adjacent blocks. But for random I/Os, only a few part
> of I/O requests can be merged, after writeback thread working for a
> while, almost all writeback I/Os are small and not stripe-aligned, even
> they are ordered by LBA address number.
> 
> Thanks.

I wonder if it'd make sense for bcache on stripe-oriented backing
devices to also try to readahead (or read-after) whole stripes from the
backing device so that they're present in the cache and then write out a
whole stripe even if the whole stripe isn't dirty.

Working with whole stripes on a RAID6 makes a huge performance difference.

-- 
Vojtech Pavlik
VP SUSE Labs
