Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 983AF11E133
	for <lists+linux-bcache@lfdr.de>; Fri, 13 Dec 2019 10:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfLMJyC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 13 Dec 2019 04:54:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:49336 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725747AbfLMJyC (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 13 Dec 2019 04:54:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 01BA6AFC2;
        Fri, 13 Dec 2019 09:54:01 +0000 (UTC)
Subject: Re: bcache works on s390 now
To:     Coly Li <colyli@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Shaoxiong Li <dahefanteng@gmail.com>,
        Ruediger Oertel <ro@suse.com>
References: <fdf24e85-5f91-3dd8-6199-cf60ba8e125c@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <39582f6e-8103-a0a5-b000-5b05cd7917b0@suse.de>
Date:   Fri, 13 Dec 2019 10:54:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <fdf24e85-5f91-3dd8-6199-cf60ba8e125c@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/12/19 3:33 PM, Coly Li wrote:
> Hi folks,
> 
> After a long time effort, now bcache can work on s390 machine.
> 
> The kernel part is ready since Linux v5.4, the bcache-tools should be
> updated too from,
> https://git.kernel.org/pub/scm/linux/kernel/git/colyli/bcache-tools.git/
> 
> The update for bcache-tools-1.1 is necessary, it fixes a super block
> checksum issue which makes kernel code treats the registering device as
> broken.
> 
> I only test bcache on a machine with vendir_id: IBM/S390, not sure
> whether it also works on s390x. If you have interest to deploy bcache on
> s390 or other big endian machines, I will appreciate if you may offer a
> result whether bcache works or not on your machine. Of cause if it does
> not work, I'd like to look into the problem and try to fix them.
> 
> BTW. Since bcache-tools is not updated for quite a long time, now I
> start to take the maintenance of bcache-tools. And please permit me to
> thank Shaoxiong Li for contributing many useful patches.
> 
> Just for your information.
> 
Congrats!

Now that is very good news indeed.
I'll be sure to notify our contacts at IBM here. And we should get 
together to figure out how a likely deployment on mainframe could look like.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
