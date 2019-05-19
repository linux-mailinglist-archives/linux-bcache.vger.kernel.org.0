Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB05227A9
	for <lists+linux-bcache@lfdr.de>; Sun, 19 May 2019 19:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbfESRXq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 19 May 2019 13:23:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:34188 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726079AbfESRXq (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 19 May 2019 13:23:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E7DBBAB7D;
        Sun, 19 May 2019 12:55:01 +0000 (UTC)
Subject: Re: modify stripe_size while running
To:     Eric Wheeler <bcache@lists.ewheeler.net>
References: <alpine.LRH.2.11.1905190127420.27699@mx.ewheeler.net>
Cc:     linux-bcache@vger.kernel.org
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <d3f7fd44-9287-c7fa-ee95-c3b8a4d56c93@suse.de>
Date:   Sun, 19 May 2019 20:54:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.11.1905190127420.27699@mx.ewheeler.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/5/19 9:30 上午, Eric Wheeler wrote:
> Hi Coly,
> 
> What would it take to enable live modification of stripe_size in sysfs?
> 
> It auto-detects for md-raid[56], but for hardware controllers it would be 
> nice to set the expensive stripe size to get the performance benefit 
> there, too.
> 
> What do you think?

Hi Eric,

It sounds interesting.

Should it be a bcache-tools parameter, or a kernel sysfs interface ? Now
I am looking at other bcache problem. If you may provide a patch, I can
help to review and merge it.

Thanks in advance.

-- 

Coly Li
