Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2731A10E117
	for <lists+linux-bcache@lfdr.de>; Sun,  1 Dec 2019 09:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfLAIpd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 1 Dec 2019 03:45:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:37926 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725847AbfLAIpd (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 1 Dec 2019 03:45:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A0DE8AE47;
        Sun,  1 Dec 2019 08:45:31 +0000 (UTC)
Subject: Re: Backport bcache v5.4 to v4.19
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     linux-bcache@vger.kernel.org
References: <alpine.LRH.2.11.1911302229090.31846@mx.ewheeler.net>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <cf687ad0-ca8a-dd9a-5959-079762c7a7e5@suse.de>
Date:   Sun, 1 Dec 2019 16:45:23 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.11.1911302229090.31846@mx.ewheeler.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/12/1 6:34 上午, Eric Wheeler wrote:
> Hi Coly,
> 
> We use 4.19.y and there have been many performance and stability changes 
> since then.  I'm considering backporting the 5.4 version into 4.19 and 
> wondered:
> 
> Are there any changes in bcache between 4.19 and 5.4 that depend on new 
> features elsewhere in the kernel, or should I basically be able to copy 
> the tree from 5.4 to 4.19 and fix minor compilation issues?
> 
> Can you think of any issues that would arise from such a backport?

Hi Eric,

It should be OK to backport bcache patches from 5.4 to 4.19. I did
similar thing for SUSE Enterprise kernel which were based on Linux 4.12
code base, and the changes was tiny.

If you encounter problem during the backport, you may post the .rej file
and maybe I can help.


-- 

Coly Li
