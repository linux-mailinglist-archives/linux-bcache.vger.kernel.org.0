Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33101F8B95
	for <lists+linux-bcache@lfdr.de>; Tue, 12 Nov 2019 10:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbfKLJTM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 12 Nov 2019 04:19:12 -0500
Received: from relay1.allsecuredomains.com ([159.69.87.227]:45493 "EHLO
        relay1.allsecuredomains.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725954AbfKLJTM (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 12 Nov 2019 04:19:12 -0500
X-Greylist: delayed 1482 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Nov 2019 04:19:10 EST
Received: from [81.174.144.187] (helo=zebedee.buttersideup.com)
        by relay1.allsecuredomains.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <tim@buttersideup.com>)
        id 1iURwQ-0002mB-Fu; Tue, 12 Nov 2019 09:54:26 +0100
Received: from [IPv6:2001:470:1b4a::318] (ermintrude.lan [IPv6:2001:470:1b4a::318])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by zebedee.buttersideup.com (Postfix) with ESMTPSA id DC950A0473;
        Tue, 12 Nov 2019 08:54:23 +0000 (UTC)
Subject: Re: Several bugs/flaws in the current(?) bcache implementation
To:     Christian Balzer <chibi@gol.com>, Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
References: <20191111104219.6d12c4b6@batzmaru.gol.ad.jp>
 <a138b451-0a3e-2646-111e-cd095699ab0e@suse.de>
 <20191112101739.1c2517a4@batzmaru.gol.ad.jp>
 <a3d675f1-2309-d3fc-12b9-2ffb38ca5965@suse.de>
 <20191112153947.7acdc5a2@batzmaru.gol.ad.jp>
From:   Tim Small <tim@buttersideup.com>
Openpgp: preference=signencrypt
Autocrypt: addr=tim@buttersideup.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <941fdfe3-20d5-8333-6aab-d3cd7f992e31@buttersideup.com>
Date:   Tue, 12 Nov 2019 08:54:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191112153947.7acdc5a2@batzmaru.gol.ad.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


On 12/11/2019 06:39, Christian Balzer wrote:
>> From internal
>> customers and external users, the feedback of maximum writeback rate is
>> quite positive. This is the first time I realize not everyone wants it.
>>
> The full speed (1TB/s) rate will result in initially high speeds (up to
> 280MBs) in most tests, but degrade (and cause load spikes -> alarms) later
> on, often resulting in it taking LONGER than if it had stuck with the
> 4MB/s minimum rate set.
> So yes, in my case something like a 32MB/s maximum rate would probably be
> perfect.


I have some backup/archival targetted "drive-managed" SMR drives which
include a non-SMR magnetic storage cache area which can cause this sort
of behaviour.

Sustained random writes make the drives fill their cache, and then
performance falls off a cliff, since the drive must start making many
read-modify-write passes in the SMR area.

e.g. this latency result:

https://www.storagereview.com/images/seagate_archive_8tb_sata_main_4kwrite_avglatency.png

(taken from https://www.storagereview.com/node/4665) - which illustrates
performance after the drive's non-SMR internal write cache area is full.

There is somewhat similar behaviour from some SSDs (plus the additional
potential problem of thermal throttling from sustained writes, and other
internal house-keeping operations):

https://www.tweaktown.com/image.php?image=images.tweaktown.com/content/8/8/8875_005_samsung-970-evo-plus-ssd-review-96-layer-refresh_full.png


Perhaps bcache could monitor backing store write latency and back-off to
avoid this condition?

Tim.
