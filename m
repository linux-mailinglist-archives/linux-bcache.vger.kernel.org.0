Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44921C0136
	for <lists+linux-bcache@lfdr.de>; Fri, 27 Sep 2019 10:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfI0Icv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 Sep 2019 04:32:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52838 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbfI0Icv (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Sep 2019 04:32:51 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1382C10CC1F4;
        Fri, 27 Sep 2019 08:32:51 +0000 (UTC)
Received: from localhost (unknown [10.33.36.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D05960BE2;
        Fri, 27 Sep 2019 08:32:40 +0000 (UTC)
Date:   Fri, 27 Sep 2019 09:32:39 +0100
From:   Joe Thornber <thornber@redhat.com>
To:     Eric Wheeler <dm-devel@lists.ewheeler.net>
Cc:     Mike Snitzer <snitzer@redhat.com>, ejt@redhat.com,
        Coly Li <colyli@suse.de>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        lvm-devel@redhat.com, joe.thornber@gmail.com
Subject: Re: kernel BUG at drivers/md/persistent-data/dm-space-map-disk.c:178
 with scsi_mod.use_blk_mq=y
Message-ID: <20190927083239.xy6jwbkbektwqu3h@reti>
Mail-Followup-To: Eric Wheeler <dm-devel@lists.ewheeler.net>,
        Mike Snitzer <snitzer@redhat.com>, ejt@redhat.com,
        Coly Li <colyli@suse.de>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        lvm-devel@redhat.com, joe.thornber@gmail.com
References: <alpine.LRH.2.11.1909251814220.15810@mx.ewheeler.net>
 <20190925200138.GA20584@redhat.com>
 <alpine.LRH.2.11.1909261819300.15810@mx.ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1909261819300.15810@mx.ewheeler.net>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Fri, 27 Sep 2019 08:32:51 +0000 (UTC)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Eric,

On Thu, Sep 26, 2019 at 06:27:09PM +0000, Eric Wheeler wrote:
> I pvmoved the tmeta to an SSD logical volume (dm-linear) on a non-bcache 
> volume and we got the same trace this morning, so while the tdata still 
> passes through bcache, all meta operations are direct to an SSD. This is 
> still using multi-queue scsi, but dm_mod.use_blk_mq=N.
> 
> Since bcache is no longer involved with metadata operations, and since 
> this appears to be a metadata issue, are there any other reasons to 
> suspect bcache?

Did you recreate the pool, or are you just using the existing pool but with
a different IO path?  If it's the latter then there could still be something
wrong with the metadata, introduced while bcache was in the stack.

Would it be possible to send me a copy of the metadata device please so
I can double check the space maps (I presume you've run thin_check on it)?

[Assuming you're using the existing pool] Another useful experiment would be to 
thump_dump and then thin_restore the metadata, which will create totally fresh
metadata and see if you can still reproduce the issue.

Thanks,

- Joe
