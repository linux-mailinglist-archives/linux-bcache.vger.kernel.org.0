Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDF80E0DEE
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Oct 2019 23:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfJVVza (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 22 Oct 2019 17:55:30 -0400
Received: from s802.sureserver.com ([195.8.222.36]:45302 "EHLO
        s802.sureserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbfJVVza (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 22 Oct 2019 17:55:30 -0400
Received: (qmail 8884 invoked by uid 1003); 22 Oct 2019 21:55:27 -0000
Received: from unknown (HELO ?94.155.37.179?) (zimage@dni.li@94.155.37.179)
  by s802.sureserver.com with ESMTPA; 22 Oct 2019 21:55:27 -0000
Subject: Re: Very slow bcache-register: 6.4TB takes 10+ minutes
To:     Emmanuel Florac <eflorac@intellique.com>
Cc:     linux-bcache@vger.kernel.org
References: <5008cd68-9ec5-5daf-3d56-25ea8b8a7736@del.bg>
 <224a181d-06a6-2517-865d-c71595487187@suse.de>
 <20191022182341.58739ca5@harpe.intellique.com>
From:   Teodor Milkov <tm@del.bg>
Message-ID: <755a36bd-b7c9-c23d-2ec0-2806718a5b47@del.bg>
Date:   Wed, 23 Oct 2019 00:55:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191022182341.58739ca5@harpe.intellique.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 22.10.19 г. 19:23 ч., Emmanuel Florac wrote:
> Le Sun, 20 Oct 2019 14:34:25 +0800
> Coly Li <colyli@suse.de> écrivait:
>
>> So far we only have a single B+tree to contain and index all bkeys. If
>> the cached data is large, this could be slow. So I suggest to create
>> more partition and make individual cache set on each partition. In my
>> personal testing, I suggest the maximum cache set size as 2-4TB.
> Urgh. 2/4 TB is the size of common SSDs nowadays. A good use case for
> bcache would be caching a 100 TB RAID array with a couple of TB of
> SSDs. Too bad I have to fallback on using LVM cache instead.


Not sure if it's improved lately but once upon a time dm-cache had 
trouble with cache sizes larger than 1 million cache block entries or 60GB:

  https://www.redhat.com/archives/dm-devel/2016-November/msg00208.html

