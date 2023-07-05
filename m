Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4467489F9
	for <lists+linux-bcache@lfdr.de>; Wed,  5 Jul 2023 19:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbjGERQ3 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 5 Jul 2023 13:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbjGERQ2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Jul 2023 13:16:28 -0400
X-Greylist: delayed 330 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 05 Jul 2023 10:16:27 PDT
Received: from juniper.fatooh.org (juniper.fatooh.org [IPv6:2600:3c01:e000:3fa::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40133173E
        for <linux-bcache@vger.kernel.org>; Wed,  5 Jul 2023 10:16:27 -0700 (PDT)
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by juniper.fatooh.org (Postfix) with ESMTPS id BF91E40556
        for <linux-bcache@vger.kernel.org>; Wed,  5 Jul 2023 10:10:57 -0700 (PDT)
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
        by juniper.fatooh.org (Postfix) with ESMTP id 9606640623
        for <linux-bcache@vger.kernel.org>; Wed,  5 Jul 2023 10:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=fatooh.org; h=message-id
        :date:mime-version:from:to:subject:content-type
        :content-transfer-encoding; s=dkim; bh=90PRjqMcKzc4p5ykmxPvXcPKI
        gM=; b=NA5JyBO4kWgnmdwGBwhkfG6VdncDVwCCJCjDp9VbiwUCIcUfxRZYXBkuC
        0Q18Fb+zoS4GX7lpsA3wDRMg5OjIxIciwFaF2anFNC5J8XIIKCes4JI5ikOYGOBm
        6zjLpq4SNbMt+QlHLW3C0PGYw358uKM7SARwHdzWBlPw2sC1Zs=
DomainKey-Signature: a=rsa-sha1; c=simple; d=fatooh.org; h=message-id
        :date:mime-version:from:to:subject:content-type
        :content-transfer-encoding; q=dns; s=dkim; b=TFcXY3MY94K9aM9p80O
        vUJx3NiNt0T94fM6Zr/aAbm8Tjsw2mAFFzyAPgxXv4DqbguIlvZ1rWwiGyRUQvwf
        Jzg4XO7GY3wKPulp4KFCyExl94ccMDbutu7mFPycXNuckumPEqKovZj2d1Uqi4bl
        bh4WAfFtvm9iMLxYf9PeDFVA=
Received: from [198.18.0.3] (unknown [104.184.153.121])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by juniper.fatooh.org (Postfix) with ESMTPSA id 8BA6940556
        for <linux-bcache@vger.kernel.org>; Wed,  5 Jul 2023 10:10:57 -0700 (PDT)
Message-ID: <04a56e2c-a89a-5cb5-4fc6-6d445f3ce471@fatooh.org>
Date:   Wed, 5 Jul 2023 10:10:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US
From:   Corey Hickey <bugfood-ml@fatooh.org>
To:     linux-bcache@vger.kernel.org
Subject: bcache device stuck after backing device goes away, then comes back
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello,

Thank you for bcache; I've been using it successfully with almost no
problems. There's just one issue that keeps coming up for me and I
haven't found a resolution.

Sometimes a bcache device can be stuck in a registered but unusable
state. Here is an example with annotations from the kernel log.

1. Initial state: backing device /dev/sdi operational and bcache
running; bcache device is in use (part of a mounted btrfs filesystem).

[5157644.106076] bcache: register_bdev() registered backing device sdi
[5157644.116702] bcache: bch_cached_dev_attach() Caching sdi as bcache1 on set f38239bc-f726-4844-bf2b-39d400993a34


2. Backing device goes offline from poweroff, disconnect, USB reset,
etc. This is not the fault of bcache.

[5231620.175549] usb 4-1.2: USB disconnect, device number 39
[5231620.234535] sd 13:0:0:0: [sdi] Synchronizing SCSI cache
[5231620.234572] sd 13:0:0:0: [sdi] Synchronize Cache(10) failed: Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[5231625.230117] bcache: cached_dev_status_update() sdi: device offline for 5 seconds
[5231625.230125] bcache: cached_dev_status_update() bdev49: disable I/O request due to backing device offline


3. Backing device comes back online, but this time with a different
device name (/dev/sdi now becomes /dev/sdn, in this example).

[5231626.926953] usb 4-1.2: new SuperSpeed Plus Gen 2x1 USB device number 44 using xhci_hcd
[5231626.956905] usb 4-1.2: New USB device found, idVendor=174c, idProduct=55aa, bcdDevice= 1.00
[5231626.956913] usb 4-1.2: New USB device strings: Mfr=2, Product=3, SerialNumber=1
[5231626.956917] usb 4-1.2: Product: ASM1351
[5231626.956919] usb 4-1.2: Manufacturer: Asmedia
[5231626.956922] usb 4-1.2: SerialNumber: 123456789205
[5231627.009822] scsi host18: uas
[5231627.010226] scsi 18:0:0:0: Direct-Access     ASMT     2135             0    PQ: 0 ANSI: 6
[5231627.011501] sd 18:0:0:0: Attached scsi generic sg8 type 0
[5231627.011681] sd 18:0:0:0: [sdn] Spinning up disk...
[5231628.046082] .......ready
[5231634.307131] sd 18:0:0:0: [sdn] 23437770752 512-byte logical blocks: (12.0 TB/10.9 TiB)
[5231634.307140] sd 18:0:0:0: [sdn] 4096-byte physical blocks
[5231634.307263] sd 18:0:0:0: [sdn] Write Protect is off
[5231634.307266] sd 18:0:0:0: [sdn] Mode Sense: 43 00 00 00
[5231634.307400] sd 18:0:0:0: [sdn] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[5231634.307800] sd 18:0:0:0: [sdn] Preferred minimum I/O size 4096 bytes
[5231634.307803] sd 18:0:0:0: [sdn] Optimal transfer size 33553920 bytes not a multiple of preferred minimum block size (4096 bytes)
[5231634.331809] sd 18:0:0:0: [sdn] Attached SCSI disk


4. Bcache tries to attach the backing device, but it's still attached.

[5231634.503820] bcache: register_bdev() registered backing device sdn
[5231634.503827] bcache: bch_cached_dev_attach() Tried to attach sdn but duplicate UUID already attached

5. The filesystem has errors.

[5233416.742602] BTRFS error (device dm-2): bdev /dev/mapper/backup1 errs: wr 0, rd 1, flush 0, corrupt 0, gen 0
[5233416.742646] BTRFS error (device dm-2): bdev /dev/mapper/backup1 errs: wr 0, rd 2, flush 0, corrupt 0, gen 0
[5233416.745538] BTRFS error (device dm-2): bdev /dev/mapper/backup1 errs: wr 0, rd 3, flush 0, corrupt 0, gen 0
[5233416.747267] BTRFS error (device dm-2): bdev /dev/mapper/backup1 errs: wr 0, rd 4, flush 0, corrupt 0, gen 0
[5233416.747405] BTRFS error (device dm-2): bdev /dev/mapper/backup1 errs: wr 0, rd 5, flush 0, corrupt 0, gen 0
...etc.


Manually stopping the device doesn't work; the "bcache" symlink is
a broken link to the device under the old name.
$ echo 1 | sudo tee /sys/block/bcache1/bcache/stop
tee: /sys/block/bcache1/bcache/stop: No such file or directory
1
$ readlink /sys/block/bcache1/bcache
../../../pci0000:00/0000:00:01.3/0000:01:00.2/0000:02:09.0/0000:07:00.0/usb4/4-1/4-1.2/4-1.2:1.0/host13/target13:0:0/13:0:0:0/block/sdi/bcache


At this point, using the backing device via bcache seems impossible
without a reboot.
* original bcache device is still active
* can't stop the bcache device, since the backing device has a new name
* the kernel won't give the backing device the old name

Is there any way to recover from this situation without a reboot?

I'm running the Debian-provided 6.1.0-8-amd64 kernel on Debian sid. I've
seen this issue before with older kernels, too.

Thank you,
Corey
