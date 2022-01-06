Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85CAB485F0D
	for <lists+linux-bcache@lfdr.de>; Thu,  6 Jan 2022 04:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236277AbiAFDBG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 5 Jan 2022 22:01:06 -0500
Received: from mx.ewheeler.net ([173.205.220.69]:32824 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345168AbiAFC7j (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Jan 2022 21:59:39 -0500
X-Greylist: delayed 511 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Jan 2022 21:59:39 EST
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id BAFD248;
        Wed,  5 Jan 2022 18:51:07 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 37V0BCJivKBo; Wed,  5 Jan 2022 18:51:06 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 9BDC039;
        Wed,  5 Jan 2022 18:51:06 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 9BDC039
Date:   Wed, 5 Jan 2022 18:51:02 -0800 (PST)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Coly Li <colyli@suse.de>
cc:     Kai Krakow <kai@kaishome.de>, linux-bcache@vger.kernel.org,
        =?ISO-8859-15?Q?Fr=E9d=E9ric_Dumas?= <f.dumas@ellis.siteparc.fr>,
        Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: Consistent failure of bcache upgrading from 5.10 to 5.15.2
In-Reply-To: <8e25f190-c712-0244-3bfd-65f1d7c7df33@suse.de>
Message-ID: <431f7be3-3b72-110-692c-ca8a11265d3@ewheeler.net>
References: <CAC2ZOYtu65fxz6yez4H2iX=_mCs6QDonzKy7_O70jTEED7kqRQ@mail.gmail.com> <7485d9b0-80f4-4fff-5a0c-6dd0c35ff91b@suse.de> <CAC2ZOYsoZJ2_73ZBfN13txs0=zqMVcjqDMMjmiWCq=kE8sprcw@mail.gmail.com> <688136f0-78a9-cf1f-cc68-928c4316c81b@bcache.ewheeler.net>
 <8e25f190-c712-0244-3bfd-65f1d7c7df33@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-2135390258-1641437466=:4450"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2135390258-1641437466=:4450
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 23 Nov 2021, Coly Li wrote:
> On 11/20/21 8:06 AM, Eric Wheeler wrote:
> > Hi Coly, Kai, and Kent, I hope you are well!
> >
> > On Thu, 18 Nov 2021, Kai Krakow wrote:
> >
> >> Hi Coly!
> >>
> >> Reading the commit logs, it seems to come from using a non-default
> >> block size, 512 in my case (although I'm pretty sure that *is* the
> >> default on the affected system). I've checked:
> >> ```
> >> dev.sectors_per_block   1
> >> dev.sectors_per_bucket  1024
> >> ```
> >>
> >> The non-affected machines use 4k blocks (sectors per block = 8).
> > If it is the cache device with 4k blocks, then this could be a known issue
> > (perhaps) not directly related to the 5.15 release. We've hit a before:
> >    https://www.spinics.net/lists/linux-bcache/msg05983.html
> >
> > and I just talked to Frédéric Dumas this week who hit it too (cc'ed).
> > His solution was to use manufacturer disk tools to change the cachedev's
> > logical block size from 4k to 512-bytes and reformat (see below).
> >
> > We've not seen issues with the backing device using 4k blocks, but bcache
> > doesn't always seem to make 4k-aligned IOs to the cachedev.  It would be
> > nice to find a long-term fix; more and more SSDs support 4k blocks, which
> > is a nice x86 page-alignment and may provide for less CPU overhead.
> >
> > I think this was the last message on the subject from Kent and Coly:
> >
> >  > On 2018/5/9 3:59 PM, Kent Overstreet wrote:
> >  > > Have you checked extent merging?
> >  >
> >  > Hi Kent,
> >  >
> >  > Not yet. Let me look into it.
> >  >
> >  > Thanks for the hint.
> >  >
> >  > Coly Li
> 
> I tried and I still remember this, the headache is, I don't have a 4Kn SSD to
> debug and trace, just looking at the code is hard...

The scsi_debug driver can do it:
	modprobe scsi_debug sector_size=4096 dev_size_mb=$((128*1024)) 

That will give you a 128gb SCSI ram disk with 4k sectors.  If that is 
enough for a cache to test against then you could run your super-high-IO 
test against it and see what you get.  I would be curious how testing 
bcache on the scsi_debug ramdisk in writeback performs!

> If anybody can send me (in China to Beijing) a 4Kn SSD to debug and testing,
> maybe I can make some progress. Or can I configure the kernel to force a
> specific non-4Kn SSD to only accept 4K aligned I/O ?

I think the scsi_debug option above might be cheaper ;) 

But seriously, Frédéric who reported this error was using an Intel P3700 
if someone (SUSE?) wants to fund testing on real hardware.  <$150 used on 
eBay: 

I'm not sure how to format it 4k, but this is how Frédéric set it to 512 
bytes and fixed his issue:

# intelmas start -intelssd 0 -nvmeformat LBAFormat=0
# intelmas start -intelssd 1 -nvmeformat LBAFormat=0

-Eric


> 
> Coly Li
> 
> 
> 
> 
--8323328-2135390258-1641437466=:4450--
