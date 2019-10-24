Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83B70E4051
	for <lists+linux-bcache@lfdr.de>; Fri, 25 Oct 2019 01:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfJXXUM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 24 Oct 2019 19:20:12 -0400
Received: from mx.ewheeler.net ([66.155.3.69]:36568 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbfJXXUM (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 24 Oct 2019 19:20:12 -0400
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 87A15A067D;
        Thu, 24 Oct 2019 23:20:11 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id XJtCcDEWaLFn; Thu, 24 Oct 2019 23:20:08 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [66.155.3.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 9F9A4A01F9;
        Thu, 24 Oct 2019 23:20:07 +0000 (UTC)
Date:   Thu, 24 Oct 2019 23:20:07 +0000 (UTC)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
X-X-Sender: lists@mx.ewheeler.net
To:     Coly Li <colyli@suse.de>
cc:     Sergey Kolesnikov <rockingdemon@gmail.com>,
        linux-bcache@vger.kernel.org
Subject: Re: Getting high cache_bypass_misses in my setup
In-Reply-To: <11f217a7-2ea8-65c5-6317-a4f2b56aa200@suse.de>
Message-ID: <alpine.LRH.2.11.1910242318380.25870@mx.ewheeler.net>
References: <CAExpLJg86wKgY=1iPt6VMOiWbVKHU-TCQqWa0aD1OA-ype07sw@mail.gmail.com> <18e5a2af-da70-60f6-6bd9-33f585b5971b@suse.de> <alpine.LRH.2.11.1910221906210.25870@mx.ewheeler.net> <11f217a7-2ea8-65c5-6317-a4f2b56aa200@suse.de>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

> >> I have no much idea. The 4Kn SSD is totally new to me. Last time I saw
> >> Eric Wheeler reported 4Kn hard diver didn't work well as backing device,
> >> and I don't find an exact reason up to now. I am not able to say 4Kn is
> >> not supported or not, before I have such device to test...
> > 
> > We pulled the 4Kn SSD configuration, it wasn't stable back in v4.1.  Not 
> > sure if the problem has been fixed, but I don't think so.  
> > 
> > Here is the original thread:
> > 
> > https://www.spinics.net/lists/linux-bcache/msg05971.html
> Yes, this is the problem I wanted to say. Kent suggested me to look into
> the extent code, but I didn't find anything suspicious. Also I tried to
> buy a 4Kn SSD, but it seemed not for consumer market and I could not
> find it from Taobao (www.taobao.com).

Its easy to simulate with libvirt:

    <disk type='block' device='disk'>
      <driver name='qemu' type='raw' cache='none' io='native' discard='unmap'/>
      <source dev='/dev/data/coly-dev_cache'/>
      <blockio logical_block_size='4096' physical_block_size='4096'/>
      <target dev='sdd' bus='scsi'/>
      <address type='drive' controller='0' bus='0' target='0' unit='3'/>
    </disk>

Note this line:
      <blockio logical_block_size='4096' physical_block_size='4096'/>

-Eric

> 
> -- 
> 
> Coly Li
> 
