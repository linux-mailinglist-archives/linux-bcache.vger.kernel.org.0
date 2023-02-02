Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBFF68888A
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Feb 2023 21:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbjBBUsh (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 2 Feb 2023 15:48:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233146AbjBBUsZ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Feb 2023 15:48:25 -0500
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E23790A1
        for <linux-bcache@vger.kernel.org>; Thu,  2 Feb 2023 12:48:16 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id F1D4548;
        Thu,  2 Feb 2023 12:48:15 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id or6Ztqgsdytl; Thu,  2 Feb 2023 12:48:11 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 8457246;
        Thu,  2 Feb 2023 12:48:11 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 8457246
Date:   Thu, 2 Feb 2023 12:48:11 -0800 (PST)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Coly Li <colyli@suse.de>
cc:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Subject: Re: [RFC] Live resize of backing device
In-Reply-To: <E0614C66-E18B-44F7-9E96-369BC9BD44B2@suse.de>
Message-ID: <3b52d311-9ab5-5fcc-3bb3-cc844caa2eb@ewheeler.net>
References: <CAHykVA5sgGooeRjM1EepCCpZqkvtQJ_=cY8hmjqe0oQ3FLDFnQ@mail.gmail.com> <9474c19e-56f0-cb4d-68c-405c55aef281@ewheeler.net> <CAHykVA4zGN=WA4A3njQ3VdX4age2-AXq3EcW1qRTFbf=o1=yDw@mail.gmail.com> <4ddb082f-cefc-644e-2ccf-56d41207ecd3@devo.com>
 <107e8ceb-748e-b296-ae60-c2155d68352d@suse.de> <CAHykVA4WfYysOcKnQETkUyUjx_tFypFCWYG1RidRMVNqObGmRg@mail.gmail.com> <B7718488-B00D-4F72-86CA-0FF335AD633F@suse.de> <CAHykVA7_e1r9x2PfiDe8czH2WRaWtNxTJWcNmdyxJTSVGCxDHA@mail.gmail.com> <755CAB25-BC58-4100-A524-6F922E1C13DC@suse.de>
 <50e64fcd-3bd8-4175-c96e-5fa2ffe051d4@devo.com> <E0614C66-E18B-44F7-9E96-369BC9BD44B2@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1719411363-1675370891=:28752"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1719411363-1675370891=:28752
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Fri, 3 Feb 2023, Coly Li wrote:
> > 2023年1月27日 20:44，Andrea Tomassetti <andrea.tomassetti-opensource@devo.com> 写道：
> > From 83f490ec8e81c840bdaf69e66021d661751975f2 Mon Sep 17 00:00:00 2001
> > From: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
> > Date: Thu, 8 Sep 2022 09:47:55 +0200
> > Subject: [PATCH v2] bcache: Add support for live resize of backing devices
> > 
> > Signed-off-by: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
> > ---
> > Hi Coly,
> > this is the second version of the patch. As you correctly pointed out,
> > I implemented roll-back functionalities in case of error.
> > I'm testing this funcionality using QEMU/KVM vm via libvirt.
> > Here the steps:
> >  1. make-bcache --writeback -B /dev/vdb -C /dev/vdc
> >  2. mkfs.xfs /dev/bcache0
> >  3. mount /dev/bcache0 /mnt
> >  3. dd if=/dev/random of=/mnt/random0 bs=1M count=1000
> >  4. md5sum /mnt/random0 | tee /mnt/random0.md5
> >  5. [HOST] virsh blockresize <vm-name> --path <disk-path> --size <new-size>
> >  6. xfs_growfs /dev/bcache0
> >  6. Repeat steps 3 and 4 with a different file name (e.g. random1.md5)
> >  7. umount/reboot/remount and check that the md5 hashes are correct with
> >        md5sum -c /mnt/random?.md5
> 
> [snipped]
> 
> Hi Andrea,
> 
> For the above step 5, could you provide a specific command line for me to reproduce?
> 
> I tried to resize the disk by virsh from 400G to 800G, the disk resize 
> doesn’t happen online, I have to stop and restart the virtual machine 
> and see the resized disk.

Coly, 

The `virsh blockresize` command only informs the vm that the size has 
changed. You will need to resize the disk itself using `lvresize` or 
whatever your VM's backing device is. If you're backing device for the 
virtual machine is a file, then you could use `truncate -s <size> 
/file/path` before issuing `virsh blockresize`.

Another possibility: are you using virtio-blk as shown in his example, or 
a different virtual driver like virtio-scsi?

If the VM doesn't detect it you might need to do this if its a 
virtio-scsi disk on the inside:

	for i in /sys/class/scsi_host/*/scan; do echo - - - > $i; done

If you're using virtio-blk (vda) then it should be immediate.  I don't 
think IDE will work at all, and not sure about nvme.

--
Eric Wheeler

	 
> Thanks.
> 
> Coly Li
> 
> 
--8323328-1719411363-1675370891=:28752--
