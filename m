Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7503213FC8E
	for <lists+linux-bcache@lfdr.de>; Fri, 17 Jan 2020 00:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388771AbgAPXBG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 16 Jan 2020 18:01:06 -0500
Received: from mx.ewheeler.net ([173.205.220.69]:58671 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388666AbgAPXBG (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 16 Jan 2020 18:01:06 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id C8373A0440;
        Thu, 16 Jan 2020 23:01:00 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id wIAKb3fbumMm; Thu, 16 Jan 2020 23:00:30 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id D4A3CA0694;
        Thu, 16 Jan 2020 23:00:28 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net D4A3CA0694
Date:   Thu, 16 Jan 2020 23:00:18 +0000 (UTC)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
X-X-Sender: lists@mx.ewheeler.net
To:     Clodoaldo Neto <clodoaldo.pinto.neto@gmail.com>
cc:     linux-bcache@vger.kernel.org
Subject: Re: undo make-bcache (was: Re: Can't mount an encrypted backing
 device)
In-Reply-To: <CA+Z73LGmM2YV1PkADFpQghqaNVNqAGjPg+LF8NSG9UTahcxGtg@mail.gmail.com>
Message-ID: <alpine.LRH.2.11.2001162259580.23088@mx.ewheeler.net>
References: <CA+Z73LFJLiP7Z2_cDUsO4Om_8pdD6w1jTSGQB0jY5sL-+nw1Wg@mail.gmail.com> <CA+Z73LGvXa_V8t=KYPkrmeJ-xmEXmz1uAnaT=Yj5AReZgLeqhg@mail.gmail.com> <65c05b80-679b-2ccb-1bd1-a9a6887c9c51@suse.de> <20200113124415.Horde.G9hpYwu_fqvg2w0msexL3ri@webmail.nde.ag>
 <0c6c3fea-5580-3a71-264c-b383b5b4fe66@suse.de> <CA+Z73LGG1pBtT=0WN5vEyqEvzxEnqMRZ26S_2x4Gd5JPSmuXmQ@mail.gmail.com> <CA+Z73LFNxP8kDMSq74DBKDbCXpbtMA9svpc1KddkUmrk-cfnOA@mail.gmail.com> <CA+Z73LGXJOwYEb+GmPuuDi3TcJbGG=NLv-5vCRcEvB+kgr4a+A@mail.gmail.com>
 <CA+Z73LGmM2YV1PkADFpQghqaNVNqAGjPg+LF8NSG9UTahcxGtg@mail.gmail.com>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-844282404-1603318660-1579215628=:23088"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---844282404-1603318660-1579215628=:23088
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 16 Jan 2020, Clodoaldo Neto wrote:

> Em seg, 13 de jan de 2020 11:19, Coly Li <colyli@suse.de> escreveu:
> >
> > On 2020/1/13 8:44 下午, Jens-U. Mozdzen wrote:
> > > Hi Coly,
> > >
> > > jumping in here, because I was looking for a way to revert from bcache
> > > to plain device:
> > >
> > > Zitat von Coly Li <colyli@suse.de>:
> > >> The super block location of the backing disk is occupied by bcache. You
> > >> cannot mount the file system directly from the backing disk which is
> > >> formated as bcache backing device [...] (bcache offset all I/Os on
> > >> bcache device 4KB behind the requesting
> > >> LBA on backing disk).
> > >
> > > Assuming that no caching device is associated with a backing device (so
> > > the backing device is "clean" as in "containing all data blocks with the
> > > current content"), could one convert the content of a backing device to
> > > a "non-bcached device" by removing the first 4096 octets of the backing
> > > device content?
> > >
> > > Something like "dd if=backingdev of=newdev skip_bytes=4096 ..."?
> >
> > Hi Jens-U,
> >
> > you may try dmsetup to setup a linear device mapper target, and the map
> > table just skipping the first 4KB (bcache superblock area). If you are
> > lucky, I mean the real file system is not corrupted, the created device
> > mapper target can be mounted directly.
> 
> 
> I'm trying dmsetup but it does not accept anything other than 0 and 0
> at the beginning and end of the table:
> 
> # echo '0 3774578672 linear /dev/mapper/backing-device 8' | dmsetup create dmb
> device-mapper: reload ioctl on dmb  failed: Invalid argument
> Command failed.
> 
> # echo '8 3774578664 linear /dev/mapper/backing-device 0' | dmsetup create dmb
> device-mapper: reload ioctl on dmb  failed: Invalid argument
> Command failed.
> 
> I'm not sure about how it works. Is it not 8 sectors for 4k bytes?

Does dmesg give a hint?


--
Eric Wheeler



> 
> 
> Clodoaldo
> 
> >
> > --
> >
> > Coly Li
> >
> 
---844282404-1603318660-1579215628=:23088--
