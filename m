Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAAF558B06E
	for <lists+linux-bcache@lfdr.de>; Fri,  5 Aug 2022 21:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbiHETii (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 5 Aug 2022 15:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238283AbiHETii (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 5 Aug 2022 15:38:38 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8DF2F029
        for <linux-bcache@vger.kernel.org>; Fri,  5 Aug 2022 12:38:37 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id C06E046;
        Fri,  5 Aug 2022 12:38:36 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id hABVS95fQJLp; Fri,  5 Aug 2022 12:38:36 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id C08DFB;
        Fri,  5 Aug 2022 12:38:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net C08DFB
Date:   Fri, 5 Aug 2022 12:38:33 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
cc:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Subject: Re: [RFC] Live resize of backing device
In-Reply-To: <CAHykVA5sgGooeRjM1EepCCpZqkvtQJ_=cY8hmjqe0oQ3FLDFnQ@mail.gmail.com>
Message-ID: <9474c19e-56f0-cb4d-68c-405c55aef281@ewheeler.net>
References: <CAHykVA5sgGooeRjM1EepCCpZqkvtQJ_=cY8hmjqe0oQ3FLDFnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-1424852501-1659728088=:4200"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1424852501-1659728088=:4200
Content-Type: text/plain; CHARSET=ISO-8859-7
Content-Transfer-Encoding: 8BIT

On Wed, 3 Aug 2022, Andrea Tomassetti wrote:
> Hi Coly,
> In one of our previous emails you said that
> > Currently bcache doesn¢t support cache or backing device resize
> 
> I was investigating this point and I actually found a solution. I
> briefly tested it and it seems to work fine.
> Basically what I'm doing is:
>   1. Check if there's any discrepancy between the nr of sectors
> reported by the bcache backing device (holder) and the nr of sectors
> reported by its parent (slave).
>   2. If the number of sectors of the two devices are not the same,
> then call set_capacity_and_notify on the bcache device.
>   3. From user space, depending on the fs used, grow the fs with some
> utility (e.g. xfs_growfs)
> 
> This works without any need of unmounting the mounted fs nor stopping
> the bcache backing device.
 
Well done! +1, would love to see a patch for this!

 
> So my question is: am I missing something? Can this live resize cause 
> some problems (e.g. data loss)? Would it be useful if I send a patch on 
> this?

A while a go we looked into doing this.  Here is the summary of our 
findings, not sure if there are any other considerations:

  1. Create a sysfs file like /sys/block/bcache0/bcache/resize to trigger 
     resize on echo 1 >.
  2. Refactor the set_capacity() bits from  bcache_device_init() into its 
     own function.
  3. Put locks around bcache_device.full_dirty_stripes and 
     bcache_device.stripe_sectors_dirty.  Re-alloc+copy+free and zero the 
     new bytes at the end.  Grep where bcache_device.full_dirty_stripes is 
     used and make sure it is locked appropriately, probably in the 
     writeback thread, maybe other places too.

The cachedev's don't know anything about the bdev size, so (according to 
Kent) they will "just work" by referencing new offsets that were 
previously beyond the disk. (This is basically the same as resizing the 
bdev and then unregister/re-register which is how we resize bdevs now.)

As for resizing a cachedev, I've not looked at all---not sure about that 
one.  We always detach, resize, make-bcache and re-attach the new cache.  
Maybe it is similarly simple, but haven't looked.


--
Eric Wheeler



> 
> Kind regards,
> Andrea
> 
--8323328-1424852501-1659728088=:4200--
