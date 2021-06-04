Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F9E39B91A
	for <lists+linux-bcache@lfdr.de>; Fri,  4 Jun 2021 14:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhFDMiE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 4 Jun 2021 08:38:04 -0400
Received: from correo01.aragon.es ([188.244.81.25]:40574 "EHLO aragon.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229718AbhFDMiE (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 4 Jun 2021 08:38:04 -0400
Received: from aragon.es ([172.30.3.33])
        by FM2.aragon.es  with ESMTP id 154CZuZT010910-154CZuZU010910;
        Fri, 4 Jun 2021 14:35:56 +0200
Received: from [1.8.2.59] (account scastillo@aragon.es [1.8.2.59] verified)
  by aragon.es (CommuniGate Pro SMTP 6.2.12)
  with ESMTPSA id 92496978; Fri, 04 Jun 2021 14:35:56 +0200
Subject: Re: Low hit ratio and cache usage
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
References: <5b01087b-6e56-0396-774a-1c1a71fe50df@aragon.es>
 <4cc064bc-36f3-cb15-0240-610a45e49300@suse.de>
From:   Santiago Castillo Oli <scastillo@aragon.es>
Message-ID: <62f20c57-d502-c362-da84-61a47c891e6d@aragon.es>
Date:   Fri, 4 Jun 2021 14:35:56 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <4cc064bc-36f3-cb15-0240-610a45e49300@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-FE-Policy-ID: 21:5:5:aragon.es
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coli!


El 04/06/2021 a las 14:05, Coly Li escribió:
> What is the kernel version and where do you have the kernel ?  And what
> is the workload on your machine ?

I'm using debian 10 with default debian kernel (4.19.0-16-amd64) in host 
and guests.

For virtualization I'm using KVM.


There is a host, where bcache is running. The filesystem over bcache 
device is ext4. In that filesystem there is only 9 qcow2 files user by 
three VM guests. Two VM are running small nextcloud instances, another 
one is running transmission (bittorrent) for feeding debian and other 
distro iso files (30 files - 60 GiB approx.)


> Most of the read requests are missing, so they will read from backing
> device and refilled into cache device as used-and-clean data. Once there
> is no enough space to hold more read-cached data, garbage colleague may
> retire the used-and-clean data very fast and make available room for new
> refilling read data. The 19GB data might be existing data from last time gc.

Is it possible to know GC last execution time?


Regards and thank you.


-- 

___________________________________________________________

