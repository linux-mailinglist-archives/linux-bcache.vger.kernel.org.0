Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1826A4DC1
	for <lists+linux-bcache@lfdr.de>; Mon, 27 Feb 2023 23:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjB0WIg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 27 Feb 2023 17:08:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjB0WIe (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 27 Feb 2023 17:08:34 -0500
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2C710D
        for <linux-bcache@vger.kernel.org>; Mon, 27 Feb 2023 14:08:33 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id CD5D885;
        Mon, 27 Feb 2023 14:08:32 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id zuwhbWcCj1Cv; Mon, 27 Feb 2023 14:08:28 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 57C3040;
        Mon, 27 Feb 2023 14:08:28 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 57C3040
Date:   Mon, 27 Feb 2023 14:08:22 -0800 (PST)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     mingzhe <mingzhe.zou@easystack.cn>
cc:     Coly Li <colyli@suse.de>,
        Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>,
        Eric Wheeler <bcache@lists.ewheeler.net>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Subject: Re: [RFC] Live resize of backing device
In-Reply-To: <cd023413-a05c-0f63-cde7-ed019b811575@easystack.cn>
Message-ID: <f4c4ecf3-6c86-dc72-d537-e2b9f2e2b490@ewheeler.net>
References: <CAHykVA5sgGooeRjM1EepCCpZqkvtQJ_=cY8hmjqe0oQ3FLDFnQ@mail.gmail.com> <9474c19e-56f0-cb4d-68c-405c55aef281@ewheeler.net> <CAHykVA4zGN=WA4A3njQ3VdX4age2-AXq3EcW1qRTFbf=o1=yDw@mail.gmail.com> <4ddb082f-cefc-644e-2ccf-56d41207ecd3@devo.com>
 <107e8ceb-748e-b296-ae60-c2155d68352d@suse.de> <CAHykVA4WfYysOcKnQETkUyUjx_tFypFCWYG1RidRMVNqObGmRg@mail.gmail.com> <B7718488-B00D-4F72-86CA-0FF335AD633F@suse.de> <CAHykVA7_e1r9x2PfiDe8czH2WRaWtNxTJWcNmdyxJTSVGCxDHA@mail.gmail.com> <755CAB25-BC58-4100-A524-6F922E1C13DC@suse.de>
 <50e64fcd-3bd8-4175-c96e-5fa2ffe051d4@devo.com> <8C5EA413-6FBB-4483-AAFA-2BC0A083C30D@suse.de> <cd023413-a05c-0f63-cde7-ed019b811575@easystack.cn>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1658373377-1677535708=:16584"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1658373377-1677535708=:16584
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 20 Feb 2023, mingzhe wrote:
> 在 2023/2/19 17:39, Coly Li 写道:
> >> Subject: [PATCH v2] bcache: Add support for live resize of backing devices
> >>
> >> Signed-off-by: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
> > 
> > Hi Andrea,
> > 
> > I am fine with this patch and added it in my test queue now. Do you have an
> > updated version, (e.g. more coding refine or adding commit log), then I can
> > update my local version.
> > 
> > 
> Hi, Coly
> 
> I posted some patchsets about online resize.
> 
> -[PATCH v5 1/3] bcache: add dirty_data in struct bcache_device
> -[PATCH v5 2/3] bcache: allocate stripe memory when partial_stripes_expensive
> is true
> -[PATCH v5 3/3] bcache: support online resizing of cached_dev
> 
> There are some differences:
> 1. Create /sys/block/bcache0/bcache/size in sysfs to trigger resize

Can the final version name the sysfs entry "resize", because "size" sounds 
like you are setting a specific size, not triggering a resize.

--
Eric Wheeler



> 2. Allocate stripe memory only if partial_stripes_expensive is true
> 3. Simplify bcache_dev_sectors_dirty()
> 
> Since the bcache superblock uses some sectors, the actual space of the bcache
> device is smaller than the backing. In order to provide a bcache device with a
> user-specified size, we need to create a backing device with a larger space,
> and then resize bcache. So resize can specify the size is very necessary.
> 
> 
> 
> 
> > 
> > 
> >> ---
> >> Hi Coly,
> >> this is the second version of the patch. As you correctly pointed out,
> >> I implemented roll-back functionalities in case of error.
> >> I'm testing this funcionality using QEMU/KVM vm via libvirt.
> >> Here the steps:
> >>   1. make-bcache --writeback -B /dev/vdb -C /dev/vdc
> >>   2. mkfs.xfs /dev/bcache0
> >>   3. mount /dev/bcache0 /mnt
> >>   3. dd if=/dev/random of=/mnt/random0 bs=1M count=1000
> >>   4. md5sum /mnt/random0 | tee /mnt/random0.md5
> >>   5. [HOST] virsh blockresize <vm-name> --path <disk-path> --size
> >>   <new-size>
> >>   6. xfs_growfs /dev/bcache0
> >>   6. Repeat steps 3 and 4 with a different file name (e.g. random1.md5)
> >>   7. umount/reboot/remount and check that the md5 hashes are correct with
> >>         md5sum -c /mnt/random?.md5
> >>
> >> drivers/md/bcache/super.c | 84 ++++++++++++++++++++++++++++++++++++++-
> >> 1 file changed, 83 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> >> index ba3909bb6bea..1435a3f605f8 100644
> >> --- a/drivers/md/bcache/super.c
> >> +++ b/drivers/md/bcache/super.c
> >>>
> > 
> > [snipped]
> > 
> > 
> 
> 
--8323328-1658373377-1677535708=:16584--
