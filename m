Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB0938C684
	for <lists+linux-bcache@lfdr.de>; Fri, 21 May 2021 14:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbhEUMbN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 21 May 2021 08:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhEUMbM (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 21 May 2021 08:31:12 -0400
Received: from smtp.mfedv.net (smtp.mfedv.net [IPv6:2a04:6c0:2::19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230B9C061574
        for <linux-bcache@vger.kernel.org>; Fri, 21 May 2021 05:29:47 -0700 (PDT)
Received: from suse92host.mfedv.net (suse92host.mfedv.net [IPv6:2a04:6c0:2:3:0:0:0:ffff])
        by smtp.mfedv.net (8.15.2/8.15.2/Debian-10) with ESMTP id 14LCTegk013902;
        Fri, 21 May 2021 12:29:41 GMT
Received: from xoff (klappe2.mfedv.net [192.168.71.72])
        by suse92host.mfedv.net (Postfix) with ESMTP id 58068C80C5;
        Fri, 21 May 2021 14:29:40 +0200 (CEST)
        (envelope-from bcache@mfedv.net)
Date:   Fri, 21 May 2021 14:29:40 +0200
From:   Matthias Ferdinand <bcache@mfedv.net>
To:     Santiago Castillo Oli <scastillo@aragon.es>
Cc:     linux-bcache@vger.kernel.org
Subject: Re: Best strategy for caching VMs storage
Message-ID: <YKentDNRwAmEGb8X@xoff>
References: <08e95aaf-a5e5-fb32-31ea-ca35cc028fac@aragon.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <08e95aaf-a5e5-fb32-31ea-ca35cc028fac@aragon.es>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, May 21, 2021 at 01:56:16PM +0200, Santiago Castillo Oli wrote:
> Hi there.
> 
> 
> I have a host running 4 VMs using qcow2 storage on a ext4 fs over HDD. Each
> VM has 3 qcow files (system, data and swap). I know I have an I/O
> bottleneck.
> 
> I want to use bcache with an SSD to accelerate disk access but I´m not sure
> where should I put bcache on storage stack.
> 
> 
> Should I use bcache on host or in guests?
> 
> Just one bcache backing device for a single (ext4) filesystem with all qcow
> files there, or different bcache and backing devices for each qcow2 file?
> 
> 
> Right know, I prefer qcow2 over thin-lvm for storage, but i could change my
> mind if thin-lvm is a much better combination for bcache.
> 
> 
> What would be the best strategy for caching VMs storage ?
> 
> Any recommendation, please?


Hi,

not claiming to know "the best" strategy, but I would recommend

  - use a single bcache device on the host

  - either use LVM (thick provisioned) to provide block devices
    to VMs, or put a filesystem on it and store qcow2 files there as
    you did before

With lvm-thin you have all metadata activity for all your VMs in one
place. Any error there and you might lose all your VM storage at once.
Of course you should do regular backups of your VMs anyway, but I would
not start using lvm-thin unless I can have the relevant metadata volume
on redundant storage because of the blast radius.
Just my paranoic 2c :-)

Speaking of blast radius: adding an SSD to the stack will make your VMs
storage performance and availability depend on two devices, not just
one, so this might increase your failure rate. Choose a high-quality
SSD, preferably datacenter-grade equipment. And of course, do your own
performance tests to see if there is enough performance improvement to
justify the higher risk of failure.

Matthias
