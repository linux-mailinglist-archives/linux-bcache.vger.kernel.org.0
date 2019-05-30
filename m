Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0A72F8F2
	for <lists+linux-bcache@lfdr.de>; Thu, 30 May 2019 11:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfE3JDt (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 30 May 2019 05:03:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:37572 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726442AbfE3JDs (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 30 May 2019 05:03:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7B052AD09;
        Thu, 30 May 2019 09:03:47 +0000 (UTC)
Subject: Re: How many memory and ssd space are consumed by metadata of 2T
 caching ssd
To:     Jianchao Wang <jianchao.wan9@gmail.com>
Cc:     linux-bcache@vger.kernel.org
References: <3c0ef10d-41b9-7c9e-72e5-5272cf6db241@gmail.com>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <4bff739f-fad7-3b97-e291-460621def079@suse.de>
Date:   Thu, 30 May 2019 17:03:41 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <3c0ef10d-41b9-7c9e-72e5-5272cf6db241@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/5/30 11:22 上午, Jianchao Wang wrote:
> Dear guys
> 
> We have an about 200T disk array and want to use a 2T ssd to cache it.
> How many memory and ssd space are consumed by the bcache when the caching device
> is nearly used up ?

Hi Jianchao,

It heavily depends on your workload for the SSD and memory consuming. It
is better to test with your workload and get a number.

For a full random I/O on the 200T disk array, bcache may occupy around
75% free space of the SSD, and as many as memory it can require from system.

-- 

Coly Li
